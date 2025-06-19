//
//  ActivityDetailViewModel.swift
//  FLOV
//
//  Created by 조우현 on 5/31/25.
//

import Foundation
import Combine

final class ActivityDetailViewModel: ViewModelType {
    private let activityRepository: ActivityRepositoryType
    private let activityId: String
    var cancellables: Set<AnyCancellable>
    var input: Input
    @Published var output: Output
    
    init(
        activityRepository: ActivityRepositoryType,
        activityId: String,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.activityRepository = activityRepository
        self.activityId = activityId
        self.cancellables = cancellables
        self.input = input
        self.output = output
        transform()
    }
    
    struct Input {
        let fetchActivityDetail = PassthroughSubject<Void, Never>()
        let keepToggle = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var activityDetails: ActivityDetailEntity = MockDataBuilder.details
        var isLoading = false
        var isKeep = false
        
        var reservations: [ReservationEntity] = []
        var selectedDate: String? = nil
        var selectedTimeSlot: TimeSlotEntity? = nil
    }
}

// MARK: - Action
extension ActivityDetailViewModel {
    enum Action {
        case fetchActivityDetail
        case keepToggle(keepStatus: Bool)
        case selectDate(itemName: String)
        case selectTimeSlot(timeSlot: TimeSlotEntity)
    }

    func action(_ action: Action) {
        switch action {
        case .fetchActivityDetail:
            input.fetchActivityDetail.send(())
        case .keepToggle(let keepStatus):
            input.keepToggle.send(keepStatus)
        case .selectDate(let itemName):
            output.selectedDate = itemName
            output.selectedTimeSlot = nil
        case .selectTimeSlot(let timeSlot):
            output.selectedTimeSlot = timeSlot
        }
    }
}

// MARK: - Transform
extension ActivityDetailViewModel {
    func transform() {
        input.fetchActivityDetail
            .sink { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.fetchActivityDetail(id: self.activityId)
                }
            }
            .store(in: &cancellables)
        
        input.keepToggle
            .sink { [weak self] status in
                guard let self = self else { return }
                Task {
                    await self.keepToggle(id: self.activityId, keepStatus: status)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Function
extension ActivityDetailViewModel {
    @MainActor
    private func fetchActivityDetail(id: String) async {
        output.isLoading = true
        defer { output.isLoading = false }
        
        do {
            let response = try await activityRepository.detailLookup(activityId: id)
            
            output.activityDetails = response
            output.isKeep = response.summary.isKeep ?? false
            setupReservationData(response)
        } catch {
            print(error)
        }
    }
    
    private func setupReservationData(_ response: ActivityDetailEntity) {
        output.reservations = response.reservations
        
        /// 선택 가능한 첫 번째 날짜를 자동 선택
        if let firstAvailableDate = getFirstAvailableDate() {
            output.selectedDate = firstAvailableDate
        }
    }
    
    /// 선택 가능한 첫 번째 날짜 찾기
    private func getFirstAvailableDate() -> String? {
        return output.reservations.first { reservation in
            !reservation.times.allSatisfy { $0.isReserved }
        }?.itemName
    }
    
    @MainActor
    private func keepToggle(id: String, keepStatus: Bool) async {
        do {
            let response = try await activityRepository.keep(activityId: id, request: .init(keepStatus: keepStatus))
            output.isKeep = response.keepStatus
        } catch {
            print(error)
        }
    }
}

// MARK: - Helper
extension ActivityDetailViewModel {
    /// 날짜가 선택 가능한지 확인
    func isDateAvailable(_ itemName: String) -> Bool {
        guard let reservation = output.reservations.first(where: { $0.itemName == itemName }) else {
            return false
        }
        return !reservation.times.allSatisfy { $0.isReserved }
    }
    
    /// 선택된 날짜의 시간 슬롯 가져오기
    func getTimeSlotsForSelectedDate() -> [TimeSlotEntity] {
        guard let selectedDate = output.selectedDate,
              let reservation = output.reservations.first(where: { $0.itemName == selectedDate }) else {
            return []
        }
        return reservation.times
    }
    
    /// 시간을 12시간제로 변환
    func formatTime(_ time: String?) -> String {
        guard let time = time else { return "" }
        
        let components = time.split(separator: ":")
        guard let hour = Int(components.first ?? "0") else { return time }
        
        if hour == 0 {
            return "12:\(components.dropFirst().joined(separator: ":"))"
        } else if hour < 12 {
            return "\(hour):\(components.dropFirst().joined(separator: ":"))"
        } else if hour == 12 {
            return time
        } else {
            let convertedHour = hour - 12
            return "\(convertedHour):\(components.dropFirst().joined(separator: ":"))"
        }
    }
    
    /// 오전/오후 구분
    func isAfternoon(_ time: String?) -> Bool {
        guard let time = time else { return false }
        
        let components = time.split(separator: ":")
        guard let hour = Int(components.first ?? "0") else { return false }
        
        return hour >= 12
    }
}
