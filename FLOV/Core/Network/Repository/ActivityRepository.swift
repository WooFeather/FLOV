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
        let response: ActivityFileUploadResponse = try await networkManager.uploadMultipartWithRefresh(
            ActivityAPI.fileUpload,
            as: ActivityFileUploadResponse.self
        ) { form in
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
        let response: ActivityListLookupResponse = try await networkManager.callWithRefresh(ActivityAPI.listLookup(
            country: country,
            category: category,
            limit: limit,
            next: next
        ), as: ActivityListLookupResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }

    func detailLookup(activityId: String) async throws -> ActivityDetailEntity {
        let response: ActivityDetailLookupResponse = try await networkManager.callWithRefresh(ActivityAPI.detailLookup(activityId: activityId), as: ActivityDetailLookupResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }

    func keep(activityId: String, request: ActivityKeepRequest) async throws -> ActivityKeepEntity {
        let response: ActivityKeepResponse = try await networkManager.callWithRefresh(ActivityAPI.keep(activityId: activityId, request: request), as: ActivityKeepResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }

    func newListLookup(country: String?, category: String?) async throws -> ActivityListEntity {
        let response: ActivityNewListLookupResponse = try await networkManager.callWithRefresh(ActivityAPI.newListLookup(country: country, category: category), as: ActivityNewListLookupResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }

    func search(title: String?) async throws -> ActivityListEntity {
        let response: ActivitySearchResponse = try await networkManager.callWithRefresh(ActivityAPI.search(title: title), as: ActivitySearchResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }

    func keepLookup(country: String?, category: String?, limit: Int?, next: String?) async throws -> ActivityListEntity {
        let response: ActivityKeepLookupResponse = try await networkManager.callWithRefresh(ActivityAPI.keepLookup(
            country: country,
            category: category,
            limit: limit,
            next: next
        ), as: ActivityKeepLookupResponse.self)
        
        let entity = response.toEntity()
        
        return entity
    }
}
