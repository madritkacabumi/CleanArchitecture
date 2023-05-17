//
//  NetworkMonitorMock.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import Foundation
@testable import CleanArchitectureExamples
import Combine

class NetworkMonitorMock: NetworkMonitorType {
    let isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(true)
    
}
