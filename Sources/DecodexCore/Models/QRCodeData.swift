//
//  QRCodeData.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 7/9/25.
//

import Foundation

public struct QRCodeData: Codable, Equatable, Identifiable, Hashable {
    public let sid: String
    public let sessionKey: String
    public var id: String { sid }
    public var role: ConnectionRole

    public init(sid: String, sessionKey: String, role: ConnectionRole) {
        self.sid = sid
        self.sessionKey = sessionKey
        self.role = role
    }

    public func toJSON() throws -> String {
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

    public func hash(into hasher: inout Hasher) {
        hasher.combine(sid)
    }
}
