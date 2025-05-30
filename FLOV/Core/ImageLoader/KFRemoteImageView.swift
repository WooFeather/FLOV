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
    
    private var isValidImagePath: Bool {
        let ext = URL(string: path)?.pathExtension.lowercased() ?? ""
        return ["jpg", "jpeg", "png"].contains(ext)
    }
    
    var body: some View {
        GeometryReader { geometry in
            if isValidImagePath {
                KFImage(URL(string: baseURL + path))
                    // URL 조립·헤더 추가
                    .requestModifier(APIRequestModifier(baseURL: baseURL, apiKey: apiKey, accessToken: accessToken))
                    .onSuccess { result in
                        print("✅ SUCCESS: \(result.source.url?.absoluteString ?? "")")
                    }
                    .onFailure { error in
                        print("❌ FAILED: \(error) ➕ URL: \(path)")
                    }
                    // 다운샘플링
                    .downsampling(size: geometry.size)
                    .scaleFactor(UIScreen.main.scale)
                    .configureCache(for: cachePolicy)
                    .loadDiskFileSynchronously(false)
                    // 로딩 중 placeholder
                    .placeholder { ProgressView() }
                    // 뷰 사라질 때 네트워크 취소
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                // TODO: AVAssetImageGenerator로 이미지 썸네일로 대체
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.colBlack)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay {
                        Image(.imgPlay)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
            }
        }
    }
}

enum CachePolicy {
    case memoryOnly
    case diskOnly
    case memoryAndDisk
    case memoryAndDiskWithOriginal
}

extension KFImage {
    func configureCache(for policy: CachePolicy) -> KFImage {
        switch policy {
        case .memoryOnly:
            self
                .cacheMemoryOnly()
                .diskCacheAccessExtending(.none)
        case .diskOnly:
            self
                .cacheMemoryOnly(false)
                .diskCacheAccessExtending(.expirationTime(.days(7)))
        case .memoryAndDisk:
            self
                .cacheMemoryOnly(false)
                .diskCacheAccessExtending(.expirationTime(.days(7)))
        case .memoryAndDiskWithOriginal:
            self
                .cacheOriginalImage()
                .diskCacheAccessExtending(.expirationTime(.days(7)))
        }
    }
}
