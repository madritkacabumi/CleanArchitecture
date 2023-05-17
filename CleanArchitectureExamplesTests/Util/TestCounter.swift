//
//  Util.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import Foundation

class TestCounter {
    
    var count: Int = .zero
    
    func increment() {
        count += 1
    }
    
    func reset() {
        count -= 1
    }
}
