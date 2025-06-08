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
    let targetSize: CGSize
    
    let baseURL = Config.baseURL
    let apiKey = Config.sesacKey
    let accessToken = UserSecurityManager.shared.accessToken
    
    init(
        path: String,
        aspectRatio: CGFloat,
        cachePolicy: CachePolicy,
        height: CGFloat
    ) {
        self.path = path
        self.aspectRatio = aspectRatio
        self.cachePolicy = cachePolicy
        let width = height * aspectRatio
        self.targetSize = CGSize(width: width, height: height)
    }
    
    var body: some View {
        let url = URL(string: baseURL + "/v1" + path)!
        
        if url.isImageType {
            KFImage(url)
                .requestModifier(APIRequestModifier(apiKey: apiKey, accessToken: accessToken))
                .downsampling(size: targetSize)
                .scaleFactor(UIScreen.main.scale)
                .configureCache(for: cachePolicy)
                .loadDiskFileSynchronously(false)
                .placeholder { ProgressView() }
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: targetSize.width, height: targetSize.height)
                .clipped()
                .allowsHitTesting(false)
        } else if url.isVideoType {
            VideoThumbnailLoaderView(
                videoURL: url,
                targetSize: targetSize,
                aspectRatio: aspectRatio,
                apiKey: apiKey,
                accessToken: accessToken
            )
            .frame(width: targetSize.width, height: targetSize.height)
            .overlay {
                Image(.imgPlay)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .clipped()
        } else {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.colBlack)
                .frame(width: targetSize.width, height: targetSize.height)
        }
    }
}
