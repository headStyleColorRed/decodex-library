//
//  PairingModels.swift
//  decodex-library
//
//  Created by Assistant on 9/9/25.
//

import Foundation

// MARK: - Simple Pairing Terminology

/// Simple desktop keypair - just strings for now
public struct DeskKey: Codable {
    public let publicKey: String
    public let privateKey: String
    public let fingerprint: String

    public init(publicKey: String, privateKey: String, fingerprint: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.fingerprint = fingerprint
    }
}

// MARK: - Pairing QR Code

public struct PairingQRData: Codable {
    public let kind: String = "codec-pairing"
    public let desktopID: String
    public let desktopPublicKey: String
    public let desktopName: String
    public let oneTimePairingToken: String
    public let expiration: String

    public init(desktopID: String,
                desktopPublicKey: String,
                desktopName: String,
                oneTimePairingToken: String,
                expiration: String) {
        self.desktopID = desktopID
        self.desktopPublicKey = desktopPublicKey
        self.desktopName = desktopName
        self.oneTimePairingToken = oneTimePairingToken
        self.expiration = expiration
    }

    public func toJSON() throws -> String {
        let json = try JSONEncoder().encode(self)
        guard let data = String(data: json, encoding: .utf8) else {
            throw NSError(domain: "PairingQRData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])
        }
        return data
    }

    public static func fromJSON(json: String) throws -> PairingQRData {
        guard let data = json.data(using: .utf8) else {
            throw NSError(domain: "PairingQRData", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        return try JSONDecoder().decode(PairingQRData.self, from: data)
    }
}

// MARK: - Simple Pairing Messages

public struct PairRequest: Codable, Sendable {
    public var kind: String = "pair_request"
    public let device: String
    public let token: String
    public let controllerPub: String
    public let controllerLabel: String?

    public init(device: String, token: String, controllerPub: String, controllerLabel: String? = nil) {
        self.device = device
        self.token = token
        self.controllerPub = controllerPub
        self.controllerLabel = controllerLabel
    }
}

public struct PairResult: Codable {
    public let sid: String
    public let kind: String
    public let success: Bool

    public init(sid: String, kind: String, success: Bool) {
        self.sid = sid
        self.kind = kind
        self.success = success
    }
}

// MARK: - Simple Pairing State Machine

public enum PairingState: String, Codable {
    case idle = "idle"
    case waiting = "waiting"
    case paired = "paired"
    case failed = "failed"
}

// MARK: - Simple Controller Management

public struct ControllerRecord: Codable {
    public let controllerId: String
    public let controllerPub: String
    public let label: String
    public let addedAt: String
    public let revoked: Bool

    public init(controllerId: String, controllerPub: String, label: String, addedAt: String, revoked: Bool = false) {
        self.controllerId = controllerId
        self.controllerPub = controllerPub
        self.label = label
        self.addedAt = addedAt
        self.revoked = revoked
    }
}

// MARK: - Simple Configuration

public struct DeviceConfig: Codable {
    public let deviceId: String
    public let createdAt: String
    public let keyFingerprint: String
    public let desktopName: String

    public init(deviceId: String, createdAt: String, keyFingerprint: String, desktopName: String) {
        self.deviceId = deviceId
        self.createdAt = createdAt
        self.keyFingerprint = keyFingerprint
        self.desktopName = desktopName
    }
}
