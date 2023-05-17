//
//  String+Extensions.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 6.5.23.
//
import Foundation
extension String {
    /// Returns the localized String
    ///
    /// - Parameter comment: comment if needed
    /// - Returns: localized String
    public func localized(_ comment: String = "", bundle: Bundle = .main) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: comment)
    }
    
    var localized: String {
        return localized(bundle: .main)
    }
    
}
