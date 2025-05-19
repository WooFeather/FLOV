//
//  ActivityRepository.swift
//  FLOV
//
//  Created by 조우현 on 5/20/25.
//

import Foundation
import Alamofire

protocol ActivityRepositoryType {
    func fileUpload(data: Data) async throws -> ActivityFileUploadResponse
    func listLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityListLookupResponse
    func detailLookup(activityId: String) async throws -> ActivityDetailLookupResponse
    func keep(activityId: String, request: ActivityKeepRequest) async throws -> ActivityKeepResponse
    func newListLookup(country: String?, category: String?) async throws -> ActivityListLookupResponse
    func search(title: String?) async throws -> ActivityListLookupResponse
    func keepLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityListLookupResponse
}

final class ActivityRepository: ActivityRepositoryType {
    private let networkManager: NetworkManagerType

    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }

    func fileUpload(data: Data) async throws -> ActivityFileUploadResponse {
        let response: ActivityFileUploadResponse = try await networkManager.uploadMultipart(ActivityAPI.fileUpload) { form in
            form.append(
                data,
                withName: "file",
                fileName: "upload.jpg",
                mimeType: "image/jpeg"
            )
        }
        
        return response
    }

    func listLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityListLookupResponse {
        let response: ActivityListLookupResponse = try await networkManager.callRequest(
            ActivityAPI.listLookup(
                country: country,
                category: category,
                limit: limit,
                next: next
            )
        )
        
        return response
    }

    func detailLookup(activityId: String) async throws -> ActivityDetailLookupResponse {
        let response: ActivityDetailLookupResponse = try await networkManager.callRequest(
            ActivityAPI.detailLookup(activityId: activityId)
        )
        
        return response
    }

    func keep(activityId: String, request: ActivityKeepRequest) async throws -> ActivityKeepResponse {
        let response: ActivityKeepResponse = try await networkManager.callRequest(
            ActivityAPI.keep(activityId: activityId, request: request)
        )
        
        return response
    }

    func newListLookup(country: String?, category: String?) async throws -> ActivityListLookupResponse {
        let response: ActivityListLookupResponse = try await networkManager.callRequest(
            ActivityAPI.newListLookup(country: country, category: category)
        )
        
        return response
    }

    func search(title: String?) async throws -> ActivityListLookupResponse {
        let response: ActivityListLookupResponse = try await networkManager.callRequest(
            ActivityAPI.search(title: title)
        )
        
        return response
    }

    func keepLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityListLookupResponse {
        let response: ActivityListLookupResponse = try await networkManager.callRequest(
            ActivityAPI.keepLookup(
                country: country,
                category: category,
                limit: limit,
                next: next
            )
        )
        
        return response
    }
}
