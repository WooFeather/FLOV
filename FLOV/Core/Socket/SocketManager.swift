//
//  SocketManager.swift
//  FLOV
//
//  Created by 조우현 on 6/5/25.
//

import Foundation
import SocketIO
import Combine

protocol SocketManagerType: ObservableObject {
    func connect(roomId: String) async
    func disconnect() async
    var messageReceived: AnyPublisher<ChatMessageEntity, Never> { get }
    var connectionStatus: AnyPublisher<SocketIOStatus, Never> { get }
    var currentRoomId: String? { get }
}

final class SocketManager: SocketManagerType {
    static let shared = SocketManager()
    
    private var manager: SocketIO.SocketManager?
    private var socket: SocketIOClient?
    private(set) var currentRoomId: String?
    
    // Combine Publishers
    private let messageSubject = PassthroughSubject<ChatMessageEntity, Never>()
    private let connectionSubject = PassthroughSubject<SocketIOStatus, Never>()
    
    var messageReceived: AnyPublisher<ChatMessageEntity, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    var connectionStatus: AnyPublisher<SocketIOStatus, Never> {
        connectionSubject.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func connect(roomId: String) async {
        await disconnect() // 기존 연결 해제
        
        currentRoomId = roomId
        
        guard let baseURL = URL(string: Config.baseURL),
              let accessToken = UserSecurityManager.shared.accessToken else {
            print("❌ Socket connection failed - Invalid URL or Token")
            return
        }
        
        let config: SocketIOClientConfiguration = [
            .log(false),
            .compress,
            .extraHeaders([
                "Authorization": accessToken,
                "SeSACKey": Config.sesacKey
            ])
        ]
        
        // 소켓 URL 구성: {baseURL}:{port}/chats-{room_id}
        let socketURL = "\(baseURL)/chats-\(roomId)"
        
        manager = SocketIO.SocketManager(socketURL: baseURL, config: config)
        socket = manager?.socket(forNamespace: "/chats-\(roomId)")
        setupSocketEvents()
        socket?.connect()
        
        print("🔌 Socket connecting to: \(socketURL)")
    }
    
    func disconnect() async {
        socket?.disconnect()
        socket?.removeAllHandlers()
        socket = nil
        manager = nil
        print("🔌 Socket disconnected")
    }
    
    private func setupSocketEvents() {
        guard let socket = socket else { return }
        
        // 연결 상태 이벤트
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("✅ Socket connected")
            self?.connectionSubject.send(.connected)
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("❌ Socket disconnected")
            self?.connectionSubject.send(.disconnected)
        }
        
        socket.on(clientEvent: .error) { [weak self] data, ack in
            print("❌ Socket error: \(data)")
            self?.connectionSubject.send(.disconnected)
        }
        
        socket.on(clientEvent: .reconnect) { [weak self] data, ack in
            print("🔄 Socket reconnected")
            self?.connectionSubject.send(.connected)
        }
        
        // 채팅 메시지 수신
        socket.on("chat") { [weak self] data, ack in
            self?.handleReceivedMessage(data: data)
        }
    }
    
    private func handleReceivedMessage(data: [Any]) {
        guard let messageData = data.first as? [String: Any] else {
            print("❌ Invalid message data format")
            return
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageData)
            let decoder = JSONDecoder()
            
            // ISO8601 날짜 형식 설정
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            // 메시지 디코딩
            let message = try decoder.decode(SocketMessageResponse.self, from: jsonData)
            let entity = message.toEntity()
            
            print("📥 Message received: \(entity.content)")
            messageSubject.send(entity)
            
        } catch {
            print("❌ Failed to decode message: \(error)")
        }
    }
}
