//
//  APIResource.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

public protocol APIResource {
    
//    var method: HTTPMethod { get } some additional stuff that a resource might have
    var requestURLString: String { get }
    var headers: [String: String]? { get }
}
