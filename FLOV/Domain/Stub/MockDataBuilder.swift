//
//  MockDataBuilder.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import Foundation

// TODO: 각 Repository에 따라 MockDataBuilder 생성
struct MockDataBuilder {
    static var ads: [AdBannerEntity] {
        return [
            AdBannerEntity(
                name: "메인배너1",
                imageUrl: "https://example.com/files/main1.jpg",
                payload: PayloadEntity(type: "webview", value: "https://example.com/event1")
            ),
            AdBannerEntity(
                name: "메인배너2",
                imageUrl: "https://example.com/files/main2.jpg",
                payload: PayloadEntity(type: "webview", value: "https://example.com/event2")
            ),
            AdBannerEntity(
                name: "메인배너3",
                imageUrl: "https://example.com/files/main3.jpg",
                payload: PayloadEntity(type: "webview", value: "https://example.com/event3")
            )
        ]
    }
    
    static var details: ActivityDetailEntity {
        return .init(
            summary: .init(
                id: "60f7e1b3d4f3e0a8d4c3f4b0",
                title: "신나는 서울 야경 투어",
                country: "대한민국",
                category: "투어",
                thumbnailURLs: [
                    "/data/activities/seoul_night_1_1746814739531.jpg"
                ],
                location: (latitude: 37.5642135, longitude: 127.0016985),
                originalPrice: 20000,
                finalPrice: 18000,
                tags: [
                    "New 액티비티 오픈할인"
                ],
                pointReward: 1000,
                isKeep: true,
                keepCount: 120
            ),
            description: "아름다운 서울의 밤을 경험하세요.",
            startDate: "2024-08-01".toDate(format: "yyyy-MM-dd"),
            endDate: "2024-12-31".toDate(format: "yyyy-MM-dd"),
            schedule: [.init(
                duration: "시작 - 10분",
                description: "간단한 일정 소개"
            )],
            reservations: [.init(
                itemName: "5월 6일",
                times: [.init(
                    time: "10:00",
                    isReserved: false
                )]
            )],
            restrictions: .init(
                minHeight: 140,
                minAge: 10,
                maxParticipants: 20
            ),
            totalOrderCount: 75,
            creator: .init(
                id: "65c9aa6932b0964405117d97",
                nick: "김새싹",
                profileImageURL: "/data/profiles/1707716853682.png",
                introduction: "안녕하세요!"
            ),
            createdAt: "2025-05-31T04:33:35.121Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date(),
            updatedAt: "2025-05-31T04:33:35.121Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        )
    }
    
    static var reservation: [ReservationEntity] {
        return [
            ReservationEntity(itemName: "8월 4일", times: [
                TimeSlotEntity(time: "10:00", isReserved: true),
                TimeSlotEntity(time: "11:00", isReserved: true),
                TimeSlotEntity(time: "12:00", isReserved: true),
                TimeSlotEntity(time: "13:00", isReserved: true),
                TimeSlotEntity(time: "14:00", isReserved: true),
                TimeSlotEntity(time: "15:00", isReserved: true),
                TimeSlotEntity(time: "16:00", isReserved: true),
                TimeSlotEntity(time: "17:00", isReserved: true)
            ]),
            ReservationEntity(itemName: "8월 5일", times: [
                TimeSlotEntity(time: "10:00", isReserved: true),
                TimeSlotEntity(time: "11:00", isReserved: false),
                TimeSlotEntity(time: "12:00", isReserved: false),
                TimeSlotEntity(time: "13:00", isReserved: true),
                TimeSlotEntity(time: "14:00", isReserved: false),
                TimeSlotEntity(time: "15:00", isReserved: false),
                TimeSlotEntity(time: "16:00", isReserved: false),
                TimeSlotEntity(time: "17:00", isReserved: false)
            ]),
            ReservationEntity(itemName: "8월 6일", times: [
                TimeSlotEntity(time: "10:00", isReserved: false),
                TimeSlotEntity(time: "11:00", isReserved: false),
                TimeSlotEntity(time: "12:00", isReserved: true),
                TimeSlotEntity(time: "13:00", isReserved: true),
                TimeSlotEntity(time: "14:00", isReserved: false),
                TimeSlotEntity(time: "15:00", isReserved: false),
                TimeSlotEntity(time: "16:00", isReserved: false),
                TimeSlotEntity(time: "17:00", isReserved: false)
            ]),
            ReservationEntity(itemName: "12월 31일", times: [
                TimeSlotEntity(time: "10:00", isReserved: true),
                TimeSlotEntity(time: "11:00", isReserved: true),
                TimeSlotEntity(time: "12:00", isReserved: true),
                TimeSlotEntity(time: "13:00", isReserved: true),
                TimeSlotEntity(time: "14:00", isReserved: true),
                TimeSlotEntity(time: "15:00", isReserved: true),
                TimeSlotEntity(time: "16:00", isReserved: true),
                TimeSlotEntity(time: "17:00", isReserved: true)
            ])
        ]
    }
}
