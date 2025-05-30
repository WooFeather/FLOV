//
//  KFRemoteImageView.swift
//  FLOV
//
//  Created by 조우현 on 5/29/25.
//

import SwiftUI
import Kingfisher

struct KFRemoteImageView: View {
    let path: String
    let aspectRatio: CGFloat
    let cachePolicy: CachePolicy

    let baseURL = Config.baseURL
    let apiKey = Config.sesacKey
    let accessToken = TokenManager.shared.accessToken
    
    private var fileExtension: String {
        URL(string: path)?.pathExtension.lowercased() ?? ""
    }
    
    var body: some View {
        GeometryReader { geometry in
            let urlString = URL(string: baseURL + "/v1" + path)!
            if urlString.isImageType {
                KFImage(urlString)
                    .requestModifier(APIRequestModifier(baseURL: baseURL, apiKey: apiKey, accessToken: accessToken))
                    .onSuccess { result in
                        print("✅ SUCCESS: \(result.source.url?.absoluteString ?? "")")
                    }
                    .onFailure { error in
                        print("❌ FAILED: \(error) ➕ URL: \(path)")
                    }
                    .downsampling(size: geometry.size)
                    .scaleFactor(UIScreen.main.scale)
                    .configureCache(for: cachePolicy)
                    .loadDiskFileSynchronously(false)
                    .placeholder { ProgressView() }
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else if urlString.isVideoType {
                VideoThumbnailLoaderView(
                    videoURL: urlString,
                    targetSize: geometry.size,
                    contentAspectRatio: aspectRatio,
                    apiKey: apiKey,
                    accessToken: accessToken
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay {
                    Image(.imgPlay)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .clipped()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.colBlack)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
