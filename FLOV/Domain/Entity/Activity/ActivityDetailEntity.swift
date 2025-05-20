//
//  ActivityDetailEntity.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation

struct ActivityListEntity {
    let data: [ActivitySummaryEntity]
    let nextCursor: String?
}

struct ActivityDetailEntity {
    let summary: ActivitySummaryEntity
    let description: String?
    let startDate: Date?
    let endDate: Date?
    let schedule: [ScheduleEntity]
    let reservations: [ReservationEntity]
    let restrictions: RestrictionsEntity
    let totalOrderCount: Int
    let creator: CreatorEntity
    let createdAt: Date
    let updatedAt: Date
}

struct ScheduleEntity {
    let duration: String?
    let description: String?
}

struct ReservationEntity {
    let itemName: String
    let times: [TimeSlotEntity]
}

struct TimeSlotEntity {
    let time: String?
    let isReserved: Bool
}

struct RestrictionsEntity {
    let minHeight: Int
    let minAge: Int
    let maxParticipants: Int
}

struct CreatorEntity {
    let id: String
    let nick: String
    let profileImageURL: String?
    let introduction: String?
}
