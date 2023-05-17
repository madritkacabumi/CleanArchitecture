//
//  TransactionListResource.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

struct TransactionListResource: APIResource {
    
    var requestURLString: String {
        return ApiEndpointConfig.transactions.endpoint
    }
    var headers: [String : String]? { return nil }
}
