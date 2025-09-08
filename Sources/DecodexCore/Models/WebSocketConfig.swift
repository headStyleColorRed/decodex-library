//
//  WebSocketConfig.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 8/9/25.
//

import Foundation

public struct WebSocketConfig {
    public let host: String
    public let port: Int
    public let path: String
    public let webProtocol: String

    private var baseURL: String {
        return "\(webProtocol)://\(host):\(port)"
    }

    private var fullURL: String {
        return "\(baseURL)\(path)"
    }

    public init(environment: AppEnvironment) {
        switch environment {
        case .debug:
            self.host = "192.168.1.78"
            self.port = 8080
            self.path = "/ws"
            self.webProtocol = "ws"
        case .staging:
            self.host = "staging.decodex.io"
            self.port = 443
            self.path = "/ws"
            self.webProtocol = "wss"
        case .release:
            self.host = "decodex.io"
            self.port = 443
            self.path = "/ws"
            self.webProtocol = "wss"
        }
    }

    public func endpoint(data: QRCodeData) -> String {
        return "\(fullURL)?sid=\(data.sid)&role=\(data.role.rawValue)&proto=\(Version.v1.rawValue)"
    }
}
