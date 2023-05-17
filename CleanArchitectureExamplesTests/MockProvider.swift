//
//  MockProvider.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import Foundation
@testable import CleanArchitectureExamples

struct MockProvider {
    
    static var transactionListProvider: [Transaction]? {
        Self.readMockJsonFile(jsonFileName: "SampleTransactions")
    }
    
}

extension MockProvider {
    
    private static func readMockJsonFile<E: Codable>(jsonFileName: String) -> E? {
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(E.self, from: data) {
            return decoded
        }
        
        return nil
    }
}
