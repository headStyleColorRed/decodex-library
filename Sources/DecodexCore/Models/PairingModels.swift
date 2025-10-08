//
//  PairingModels.swift
//  decodex-library
//
//  Created by Assistant on 9/9/25.
//

import Foundation

// MARK: - Simple Pairing Terminology

/// Stable random ID for this desktop install (UUIDv4)
public typealias DeviceID = String

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

/// One-time pairing token
public typealias PairToken = String

/// Controller public key
public typealias ControllerPub = String

/// Relay endpoint URL
public typealias RelayURL = String

// MARK: - Pairing QR Code

public struct PairingQRData: Codable {
    public let kind: String = "codec-pairing"
    public let relay: RelayURL
    public let device: DeviceID
    public let deskPub: String // Base64(DeskKey.public)
    public let token: PairToken // Base64(PairToken)
    public let exp: String // ISO8601 expiration
    public let desktopName: String

    public init(relay: RelayURL, device: DeviceID, deskPub: String, token: PairToken, exp: String, desktopName: String) {
        self.relay = relay
        self.device = device
        self.deskPub = deskPub
        self.token = token
        self.exp = exp
        self.desktopName = desktopName
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

public struct PairRequest: Codable {
    public let kind: String = "pair_request"
    public let device: DeviceID
    public let token: PairToken
    public let controllerPub: ControllerPub
    public let controllerLabel: String?

    public init(device: DeviceID, token: PairToken, controllerPub: ControllerPub, controllerLabel: String? = nil) {
        self.device = device
        self.token = token
        self.controllerPub = controllerPub
        self.controllerLabel = controllerLabel
    }
}

public struct PairResult: Codable {
    public let kind: String = "pair_result"
    public let success: Bool
    public let error: String?

    public init(success: Bool, error: String? = nil) {
        self.success = success
        self.error = error
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
    public let controllerPub: ControllerPub
    public let label: String
    public let addedAt: String
    public let revoked: Bool

    public init(controllerId: String, controllerPub: ControllerPub, label: String, addedAt: String, revoked: Bool = false) {
        self.controllerId = controllerId
        self.controllerPub = controllerPub
        self.label = label
        self.addedAt = addedAt
        self.revoked = revoked
    }
}

// MARK: - Simple Configuration

public struct DeviceConfig: Codable {
    public let deviceId: DeviceID
    public let relayUrl: RelayURL
    public let createdAt: String
    public let keyFingerprint: String
    public let desktopName: String

    public init(deviceId: DeviceID, relayUrl: RelayURL, createdAt: String, keyFingerprint: String, desktopName: String) {
        self.deviceId = deviceId
        self.relayUrl = relayUrl
        self.createdAt = createdAt
        self.keyFingerprint = keyFingerprint
        self.desktopName = desktopName
    }
}

// MARK: - Simple Error Types

public enum PairingError: Error, LocalizedError {
    case tokenExpired
    case tokenInvalid
    case deviceMismatch
    case controllerAlreadyPaired

    public var errorDescription: String? {
        switch self {
        case .tokenExpired:
            return "Pairing token has expired"
        case .tokenInvalid:
            return "Invalid pairing token"
        case .deviceMismatch:
            return "Device ID mismatch"
        case .controllerAlreadyPaired:
            return "Controller is already paired"
        }
    }
}
