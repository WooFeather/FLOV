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
    func newListLookup(country: String?, category: String?) async throws -> ActivityNewListLookupResponse
    func search(title: String?) async throws -> ActivitySearchResponse
    func keepLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityKeepLookupResponse
}

final class ActivityRepository: ActivityRepositoryType {
    private let networkManager: NetworkManagerType

    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }

    func fileUpload(data: Data) async throws -> ActivityFileUploadResponse {
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
        return response
    }

    func listLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityListLookupResponse {
        try await networkManager.callWithRefresh(ActivityAPI.listLookup(
            country: country,
            category: category,
            limit: limit,
            next: next
        ), as: ActivityListLookupResponse.self)
    }

    func detailLookup(activityId: String) async throws -> ActivityDetailLookupResponse {
        try await networkManager.callWithRefresh(ActivityAPI.detailLookup(activityId: activityId), as: ActivityDetailLookupResponse.self)
    }

    func keep(activityId: String, request: ActivityKeepRequest) async throws -> ActivityKeepResponse {
        try await networkManager.callWithRefresh(ActivityAPI.keep(activityId: activityId, request: request), as: ActivityKeepResponse.self)
    }

    func newListLookup(country: String?, category: String?) async throws -> ActivityNewListLookupResponse {
        try await networkManager.callWithRefresh(ActivityAPI.newListLookup(country: country, category: category), as: ActivityNewListLookupResponse.self)
    }

    func search(title: String?) async throws -> ActivitySearchResponse {
        try await networkManager.callWithRefresh(ActivityAPI.search(title: title), as: ActivitySearchResponse.self)
    }

    func keepLookup(country: String?, category: String?, limit: String?, next: String?) async throws -> ActivityKeepLookupResponse {
        try await networkManager.callWithRefresh(ActivityAPI.keepLookup(
            country: country,
            category: category,
            limit: limit,
            next: next
        ), as: ActivityKeepLookupResponse.self)
    }
}
