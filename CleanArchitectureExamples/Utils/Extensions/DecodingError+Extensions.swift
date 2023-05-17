//
//  DecodingError+Extensions.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

extension DecodingError {
    
    static var invalidParsingDate: Error {
        // TODO: Create a better error to rapresent failure in parsing dates
        return NSError(domain: "", code: -555, userInfo: nil)
    }
    
    static var invalidMockData: Error {
        // TODO: Create a better error to rapresent failure in parsing dates
        return NSError(domain: "", code: -123, userInfo: nil)
    }
}
