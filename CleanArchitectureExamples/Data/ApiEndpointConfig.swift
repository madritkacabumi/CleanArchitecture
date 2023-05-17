//
//  ApiEndpointConfig.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

enum ApiEndpointConfig {
    
    case transactions
    
    // MARK: - Endpoint
    private var baseEndpoint: String {
        return "https://mydomain.example.com"
    }
    
    private var path: String {
        switch self {
            case .transactions:
                return "/transactions"
                
        }
    }
    
    var endpoint: String {
        switch self {
            case .transactions:
                return "\(baseEndpoint)/\(self.path))"
        }
    }
    
}

