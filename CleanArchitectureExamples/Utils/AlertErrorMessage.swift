//
//  AlertMessage.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import Foundation

struct AlertErrorMessage {
    
    public let message: String
    public var isShowing: Bool
    
     init(message: String, isShowing: Bool) {
        self.message = message
        self.isShowing = isShowing
    }
    
    init() {
        self.message = ""
        self.isShowing = false
    }
    
}
