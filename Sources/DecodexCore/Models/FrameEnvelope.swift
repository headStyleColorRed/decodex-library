import Foundation

/// Message framing structure for relayed messages
public struct FrameEnvelope: Codable, Sendable {
    public let sid: UUID
    public let seq: UInt64
    public let type: FrameType
    public let bufferable: Bool
    public let body: String // base64 encoded ciphertext

    public enum FrameType: String, Codable, Sendable {
        case data = "data"
        case control = "control"
        case ping = "ping"
    }

    public init(sid: UUID, seq: UInt64, type: FrameType, bufferable: Bool, body: String) {
        self.sid = sid
        self.seq = seq
        self.type = type
        self.bufferable = bufferable
        self.body = body
    }

    /// Validates the envelope against session requirements
    public func validate(for sessionID: UUID) -> ValidationResult {
        guard sid == sessionID else {
            return .invalid("Session ID mismatch")
        }

        guard body.count > 0 else {
            return .invalid("Empty body")
        }

        return .valid
    }
}

public enum ValidationResult: Sendable {
    case valid
    case invalid(String)

    public var isValid: Bool {
        if case .valid = self { return true }
        return false
    }

    public var errorMessage: String? {
        if case .invalid(let message) = self { return message }
        return nil
    }
}
