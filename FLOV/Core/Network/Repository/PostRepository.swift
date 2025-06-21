//
//  PostRepository.swift
//  FLOV
//
//  Created by 조우현 on 6/21/25.
//

import Foundation
import Alamofire

protocol PostRepositoryType {
    func fileUpload(data: Data) async throws -> FileUploadEntity
    func postWrite(request: PostWriteRequest) async throws -> PostEntity
    func postLookup(country: String?, category: String?, longitude: Double?, latitude: Double?, maxDistance: String?, limit: Int?, next: String?, orderBy: String?) async throws -> PostListEntity
    func postSearch(title: String?) async throws -> PostListEntity
    func postDetailLookup(postId: String) async throws -> PostEntity
    func postModification(postId: String, request: PostModificationRequest) async throws -> PostEntity
    func postDelete(postId: String) async throws
    func postLike(postId: String, request: PostLikeRequest) async throws -> PostLikeEntity
    func userPostLookup(country: String?, category: String?, limit: Int?, next: String?, userId: String) async throws -> PostListEntity
    func likePostLookup(country: String?, category: String?, next: String?, limit: Int?) async throws -> PostListEntity
}

final class PostRepository: PostRepositoryType {
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
    
    func fileUpload(data: Data) async throws -> FileUploadEntity {
        let response: FileUploadResponse = try await networkManager.uploadMultipart(PostAPI.fileUpload) { form in
            form.append(
                data,
                withName: "postImage",
                fileName: "postImage.png",
                mimeType: "image/png"
            )
        }
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func postWrite(request: PostWriteRequest) async throws -> PostEntity {
        let response: PostResponse = try await networkManager.callRequest(PostAPI.postWrite(request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func postLookup(country: String?, category: String?, longitude: Double?, latitude: Double?, maxDistance: String?, limit: Int?, next: String?, orderBy: String?) async throws -> PostListEntity {
        let response: PostLookupResponse = try await networkManager.callRequest(
            PostAPI.postLookup(
                country: country,
                category: category,
                longitude: longitude,
                latitude: latitude,
                maxDistance: maxDistance,
                limit: limit,
                next: next,
                orderBy: orderBy
            )
        )
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func postSearch(title: String?) async throws -> PostListEntity {
        let response: PostSearchResponse = try await networkManager.callRequest(PostAPI.postSearch(title: title))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func postDetailLookup(postId: String) async throws -> PostEntity {
        let response: PostResponse = try await networkManager.callRequest(PostAPI.postDetailLookup(postId: postId))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func postModification(postId: String, request: PostModificationRequest) async throws -> PostEntity {
        let response: PostResponse = try await networkManager.callRequest(PostAPI.postModification(postId: postId, request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func postDelete(postId: String) async throws {
        _ = try await networkManager.callRequest(PostAPI.postDelete(postId: postId)) as EmptyResponse
    }
    
    func postLike(postId: String, request: PostLikeRequest) async throws -> PostLikeEntity {
        let response: PostLikeResponse = try await networkManager.callRequest(PostAPI.postLike(postId: postId, request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func userPostLookup(country: String?, category: String?, limit: Int?, next: String?, userId: String) async throws -> PostListEntity {
        let response: PostLookupResponse = try await networkManager.callRequest(
            PostAPI.userPostLookup(
                country: country,
                category: category,
                limit: limit,
                next: next,
                userId: userId
            )
        )
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func likePostLookup(country: String?, category: String?, next: String?, limit: Int?) async throws -> PostListEntity {
        let response: PostLookupResponse = try await networkManager.callRequest(
            PostAPI.likePostLookup(
                country: country,
                category: category,
                next: next,
                limit: limit
            )
        )
        
        let entity = response.toEntity()
        
        return entity
    }
}
