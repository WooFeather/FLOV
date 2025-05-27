//
//  ActivityRepository.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation
import Alamofire

protocol ActivityRepositoryType {
    func fileUpload(data: Data) async throws -> ActivityFileUploadEntity
    func listLookup(country: String?, category: String?, limit: Int?, next: String?) async throws -> ActivityListEntity
    func detailLookup(activityId: String) async throws -> ActivityDetailEntity
    func keep(activityId: String, request: ActivityKeepRequest) async throws -> ActivityKeepEntity
    func newListLookup(country: String?, category: String?) async throws -> ActivityListEntity
    func search(title: String?) async throws -> ActivityListEntity
    func keepLookup(country: String?, category: String?, limit: Int?, next: String?) async throws -> ActivityListEntity
}

final class ActivityRepository: ActivityRepositoryType {
    private let networkManager: NetworkManagerType

    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }

    func fileUpload(data: Data) async throws -> ActivityFileUploadEntity {
        let response: ActivityFileUploadResponse = try await networkManager.uploadMultipart(ActivityAPI.fileUpload) { form in
            form.append(
                data,
                withName: "profile",
                fileName: "upload.png",
                mimeType: "image/png"
            )
        }
        
        let entity = response.toEntity()
        
        return entity
    }

    func listLookup(country: String?, category: String?, limit: Int?, next: String?) async throws -> ActivityListEntity {
        
        
        let response: ActivityListLookupResponse = try await networkManager.callRequest(ActivityAPI.listLookup(
            country: country,
            category: category,
            limit: limit,
            next: next
        ))
        
        let entity = response.toEntity()
        
        return entity
    }

    func detailLookup(activityId: String) async throws -> ActivityDetailEntity {
        let response: ActivityDetailLookupResponse = try await networkManager.callRequest(ActivityAPI.detailLookup(activityId: activityId))
        
        let entity = response.toEntity()
        
        return entity
    }

    func keep(activityId: String, request: ActivityKeepRequest) async throws -> ActivityKeepEntity {
        let response: ActivityKeepResponse = try await networkManager.callRequest(ActivityAPI.keep(activityId: activityId, request: request))
        
        let entity = response.toEntity()
        
        return entity
    }

    func newListLookup(country: String?, category: String?) async throws -> ActivityListEntity {
        let response: ActivityNewListLookupResponse = try await networkManager.callRequest(ActivityAPI.newListLookup(country: country, category: category))
        
        let entity = response.toEntity()
        
        return entity
    }

    func search(title: String?) async throws -> ActivityListEntity {
        let response: ActivitySearchResponse = try await networkManager.callRequest(ActivityAPI.search(title: title))
        
        let entity = response.toEntity()
        
        return entity
    }

    func keepLookup(country: String?, category: String?, limit: Int?, next: String?) async throws -> ActivityListEntity {
        let response: ActivityKeepLookupResponse = try await networkManager.callRequest(ActivityAPI.keepLookup(
            country: country,
            category: category,
            limit: limit,
            next: next
        ))
        
        let entity = response.toEntity()
        
        return entity
    }
}
