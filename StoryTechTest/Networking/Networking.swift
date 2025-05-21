//
//  Networking.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

import Foundation
import Factory

public enum NetworkingConfig {
    case local
    case remote
}

extension Container {
    public var networkingManager: ParameterFactory<NetworkingConfig, NetworkingProtocol> {
        self { NetworkingManager(config: $0) }
    }
}

public protocol NetworkingProtocol {
    func fetchData<T: Decodable>(from route: NetworkingRoute) async throws -> T
}

class NetworkingManager: NetworkingProtocol {
    private let config: NetworkingConfig
    
    init(config: NetworkingConfig) {
        self.config = config
    }
    
    public func fetchData<T>(from route: NetworkingRoute) async throws -> T where T : Decodable {
        switch config {
            case .local: try await fetchLocalData(route: route)
            case .remote: try await fetchRemoteData(route: route)
        }
    }
    
    private func fetchRemoteData<T>(route: NetworkingRoute) async throws -> T where T: Decodable {
        guard let url = route.remoteUrl else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    private func fetchLocalData<T>(route: NetworkingRoute) async throws -> T where T: Decodable {
        guard let url = route.localUrl else {
            throw URLError(.badURL)
        }
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}

public enum NetworkingRoute {
    case fetchStories
    
    var localUrl: URL? {
        return switch self {
            case .fetchStories:
                Bundle.main.url(forResource: "mock_users", withExtension: "json")
        }
    }
    
    var remoteUrl: URL? {
        return switch self {
            case .fetchStories: URL(string: "")
        }
    }
}
