//
//  SampleNetworkService.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation
import Combine

public typealias APIResponseObservable<E: Codable> = AnyPublisher<E, Error>

protocol SampleNetworkServiceType {
    func performRequest<E: Codable>(with resource: APIResource) -> Future<E, Error>
    func loadMock<E: Codable>(with name: String) -> Future<E, Error>
}

class SampleNetworkService: SampleNetworkServiceType {
    // NOTE: This is just a sample Network Service, or a class that would directly or indirectly create the request and would perform the network API Request. We would create a sample just for the sake of the challenge and so some components would make sense connected.
    // A realworld network service would have plenty of configurations such as Certificate pinning, cache handling, SSL Configs, etc.
    //In this example we would make it that it also reads some json files in the project and would return the parsed model
    
    /// Will Perform a request
    ///  Note:  As mentioned above we don't have in reality a realnetwork layer to call for the transactions so we will return an error
    /// - Parameter jsonFileName: json filename without extension, (The file itself must end with .json)
    /// - Returns: the Publisher with parsed model or Error
    ///
    func performRequest<E>(with resource: APIResource) -> Future<E, Error> where E : Decodable, E : Encodable {
        return Future { promise in
            promise(.failure(NSError(domain: "Some.Error.Domain", code: -1)))
        }
    }
    
    /// Read a local json mockup file and parses it
    /// - Parameter jsonFileName: json filename without extension, (The file itself must end with .json)
    /// - Returns: the Publisher with parsed model or Error
    ///
    func loadMock<E: Codable>(with name: String) -> Future<E, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                return
            }
            Task {
                do {
                    let mock: E = try await self.readMockJsonFile(jsonFileName: name)
                    promise(.success(mock))
                } catch (let error) {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
    }
    
    private func readMockJsonFile<E: Codable>(jsonFileName: String) async throws -> E {
        try await Task.sleep(until: .now + .seconds(2), clock: .continuous) // let's stop the task for 2 sec
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(E.self, from: data)
        }
        throw DecodingError.invalidMockData
    }
    
}
