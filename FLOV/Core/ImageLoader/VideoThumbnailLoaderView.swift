//
//  VideoThumbnailLoaderView.swift
//  FLOV
//
//  Created by 조우현 on 5/30/25.
//

import SwiftUI
import AVFoundation
import Kingfisher

struct VideoThumbnailLoaderView: View {
    let videoURL: URL
    let targetSize: CGSize
    let contentAspectRatio: CGFloat
    let apiKey: String
    let accessToken: String?

    @State private var thumbnailImage: Image?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            } else if let img = thumbnailImage {
                img
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.colBlack)
                    .overlay {
                        Image(.imgPlay)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
            }
        }
        .task(id: videoURL) {
            await loadOrGenerateThumbnail()
        }
    }

    private func loadOrGenerateThumbnail() async {
        let cache = ImageCache.default
        let key = videoURL.absoluteString

        // 캐시에서 이미지 가져오기
        if let result = try? await cache.retrieveImage(forKey: key),
           let uiImage = result.image {
            await MainActor.run {
                thumbnailImage = Image(uiImage: uiImage)
                isLoading = false
            }
            return
        }

        // 썸네일 생성
        let headers = [
            "SeSACKey": apiKey,
            "Authorization": accessToken ?? ""
        ]
        let asset = AVURLAsset(
            url: videoURL,
            options: ["AVURLAssetHTTPHeaderFieldsKey": headers]
        )
        // 플레이 가능 여부 확인
        guard (try? await asset.load(.isPlayable)) != nil else {
            await MainActor.run { isLoading = false }
            return
        }

        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let scale = UIScreen.main.scale
        generator.maximumSize = CGSize(
            width: targetSize.width * scale,
            height: targetSize.height * scale
        )
        let time = CMTime(seconds: 1, preferredTimescale: 600)
        
        // 만료 정책
        let infos: KingfisherOptionsInfo = [
            .memoryCacheExpiration(.days(1)),
            .diskCacheExpiration(.days(7))
        ]
        
        let parsed = KingfisherParsedOptionsInfo(infos)

        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            // 캐시에 저장 (memory+disk)
            try await cache.store(uiImage, forKey: key, options: parsed)
            await MainActor.run {
                thumbnailImage = Image(uiImage: uiImage)
                isLoading = false
            }
        }
        catch {
            await MainActor.run { isLoading = false }
            print("❌ Thumbnail generation failed:", error)
        }
    }
}
