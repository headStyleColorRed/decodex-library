//
//  QRCodeData.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 7/9/25.
//

import Foundation

public struct QRCodeData: Codable {
    public let sid: String
    public let relayURL: String
    public let sessionKey: Base64

    public init(sid: String, relayURL: String, sessionKey: Base64) {
        self.sid = sid
        self.relayURL = relayURL
        self.sessionKey = sessionKey
    }

    public func toJSON() throws -> String? {
        let json = try JSONEncoder().encode(self)
        guard let data = String(data: json, encoding: .utf8) else {
            throw NSError(domain: "QRCodeData", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])
        }
        return data
    }

    public static func fromJSON(json: String) throws -> QRCodeData {
        guard let data = json.data(using: .utf8) else {
            throw NSError(domain: "QRCodeData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        return try JSONDecoder().decode(QRCodeData.self, from: data)
    }
}
