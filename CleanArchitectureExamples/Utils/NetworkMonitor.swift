//
//  NetworkMonitor.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 5.5.23.
//

import Network
import Foundation
import Combine

protocol NetworkMonitorType {
    var isConnected: CurrentValueSubject<Bool, Never> { get }
}

class NetworkMonitor: ObservableObject, NetworkMonitorType {
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    let isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected.send(path.status == .satisfied)
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
