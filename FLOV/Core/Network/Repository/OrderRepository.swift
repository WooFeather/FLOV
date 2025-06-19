//
//  OrderRepository.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation
import Alamofire

protocol OrderRepositoryType {
    func orderCreate(request: OrderCreateRequest) async throws -> OrderEntity
    func orderLookup() async throws -> [OrderEntity]
}

final class OrderRepository: OrderRepositoryType {
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
    
    func orderCreate(request: OrderCreateRequest) async throws -> OrderEntity {
        let response: OrderCreateResponse = try await networkManager.callRequest(OrderAPI.orderCreate(request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func orderLookup() async throws -> [OrderEntity] {
        let response: OrderLookupResponse = try await networkManager.callRequest(OrderAPI.orderLookup)
        
        let entity = response.data.map { $0.toEntity() }
        
        return entity
    }
}
