//
//  TransactionEntityTests.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

@testable import CleanArchitectureExamples
import Foundation
import XCTest

final class TransactionEntityTests: XCTestCase {
    
    func test_transactions() {
        XCTAssertNotNil(MockProvider.transactionListProvider)
    }
}
