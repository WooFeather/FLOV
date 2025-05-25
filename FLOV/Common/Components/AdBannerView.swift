//
//  AdBannerView.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct AdBannerView: View {
    @State private var currentPage = 0
    let banners: [AdBannerEntity]
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(banners.indices, id: \.self) { idx in
                    let banner = banners[idx]
                    AsyncImage(url: URL(string: banner.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Color.red.opacity(0.2)
                        @unknown default:
                            Color.gray
                        }
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(currentPage + 1) / \(banners.count)")
                        .font(.Caption.caption2.weight(.medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.gray75.opacity(0.3))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.trailing, 20)
                        .padding(.bottom, 12)
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    let dummy = [
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
    AdBannerView(banners: dummy)
        .background(Color.colLight)
}
