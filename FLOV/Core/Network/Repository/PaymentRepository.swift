//
//  PaymentRepository.swift
//  FLOV
//
//  Created by 조우현 on 6/19/25.
//

import Foundation
import Alamofire

protocol PaymentRepositoryType {
    func paymentValidation(request: PaymentValidationRequest) async throws -> PaymentEntity
    func receiptLookup(orderCode: String) async throws -> ReceiptEntity
}

final class PaymentRepository: PaymentRepositoryType {
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
    
    func paymentValidation(request: PaymentValidationRequest) async throws -> PaymentEntity {
        let response: PaymentValidationResponse = try await networkManager.callRequest(PaymentAPI.paymentValidation(request: request))
        
        let entity = response.toEntity()
        
        return entity
    }
    
    func receiptLookup(orderCode: String) async throws -> ReceiptEntity {
        let response: ReceiptLookupResponse = try await networkManager.callRequest(PaymentAPI.receiptLookup(orderCode: orderCode))
        
        let entity = response.toEntity()
        
        return entity
    }
}
