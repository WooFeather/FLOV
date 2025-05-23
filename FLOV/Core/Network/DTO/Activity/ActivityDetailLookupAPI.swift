//
//  ActivityDetailLookupAPI.swift
//  FLOV
//
//  Created by 조우현 on 5/19/25.
//

import Foundation

// MARK: - ActivityDetailLookupResponse
struct ActivityDetailLookupResponse: Decodable {
    let activityId: String
    let title: String?
    let country: String?
    let category: String?
    let thumbnails: [String]
    let geolocation: ActivityGeolocation
    let startDate: String?
    let endDate: String?
    let price: ActivityPrice
    let tags: [String]
    let pointReward: Int?
    let restrictions: ActivityRestrictions
    let description: String?
    let isAdvertisement: Bool
    let isKeep: Bool
    let keepCount: Int
    let totalOrderCount: Int
    let schedule: [ActivitySchedule]?
    let reservationList: [ActivityReservationList]
    let creator: ActivityCreator
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case activityId = "activity_id"
        case title
        case country
        case category
        case thumbnails
        case geolocation
        case startDate = "start_date"
        case endDate = "end_date"
        case price
        case tags
        case pointReward = "point_reward"
        case restrictions
        case description
        case isAdvertisement = "is_advertisement"
        case isKeep = "is_keep"
        case keepCount = "keep_count"
        case totalOrderCount = "total_order_count"
        case schedule
        case reservationList = "reservation_list"
        case creator
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ActivityCreator
struct ActivityCreator: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    let introduction: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
        case introduction
    }
}

// MARK: - ActivityReservationList
struct ActivityReservationList: Decodable {
    let itemName: String
    let times: [ActivityTime]

    enum CodingKeys: String, CodingKey {
        case itemName = "item_name"
        case times
    }
}

// MARK: - ActivityTime
struct ActivityTime: Decodable {
    let time: String?
    let isReserved: Bool?

    enum CodingKeys: String, CodingKey {
        case time
        case isReserved = "is_reserved"
    }
}

// MARK: - ActivityRestrictions
struct ActivityRestrictions: Decodable {
    let minHeight: Int
    let minAge: Int
    let maxParticipants: Int

    enum CodingKeys: String, CodingKey {
        case minHeight = "min_height"
        case minAge = "min_age"
        case maxParticipants = "max_participants"
    }
}

// MARK: - ActivitySchedule
struct ActivitySchedule: Decodable {
    let duration: String?
    let description: String?
}

// MARK: - Mapper
extension ActivityDetailLookupResponse {
    func toEntity() -> ActivityDetailEntity {
        let summaryDTO = ActivitySummary(
            activityId: activityId,
            title: title,
            country: country,
            category: category,
            thumbnails: thumbnails,
            geolocation: geolocation,
            price: price,
            tags: tags,
            pointReward: pointReward,
            isAdvertisement: isAdvertisement,
            isKeep: isKeep,
            keepCount: keepCount
        )
        
        return ActivityDetailEntity(
            summary: summaryDTO.toEntity(),
            description: description,
            startDate: startDate?.toDate(format: "yyyy-MM-dd"),
            endDate: endDate?.toDate(format: "yyyy-MM-dd"),
            schedule: schedule?.map {
                ScheduleEntity(
                    duration: $0.duration,
                    description: $0.description
                )
            } ?? [],
            reservations: reservationList.map {
                ReservationEntity(
                    itemName: $0.itemName,
                    times: $0.times.map {
                        TimeSlotEntity(
                            time: $0.time,
                            isReserved: $0.isReserved ?? false
                        )
                    }
                )
            },
            restrictions: RestrictionsEntity(
                minHeight: restrictions.minHeight,
                minAge: restrictions.minAge,
                maxParticipants: restrictions.maxParticipants
            ),
            totalOrderCount: totalOrderCount,
            creator: CreatorEntity(
                id: creator.userId,
                nick: creator.nick,
                profileImageURL: creator.profileImage,
                introduction: creator.introduction
            ),
            createdAt: createdAt.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date(),
            updatedAt: updatedAt.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ") ?? Date()
        )
    }
}
