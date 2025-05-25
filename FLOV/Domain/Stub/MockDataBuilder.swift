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
}
