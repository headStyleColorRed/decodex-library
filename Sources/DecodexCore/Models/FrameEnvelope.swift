import Foundation

public typealias Base64 = String

/// Message framing structure for relayed messages
public struct FrameEnvelope: Codable, Sendable {
    public let sid: UUID
    public let seq: UInt64
    public let bufferable: Bool
    public let body: Base64

    public init(sid: UUID, seq: UInt64, bufferable: Bool, body: Base64) {
        self.sid = sid
        self.seq = seq
        self.bufferable = bufferable
        self.body = body
    }

    /// Validates the envelope against session requirements
//    public func validate(for sessionID: UUID) -> ValidationResult {
//        guard sid == sessionID else {
//            return .invalid("Session ID mismatch")
//        }
//
//        guard body.count > 0 else {
//            return .invalid("Empty body")
//        }
//
//        return .valid
//    }
}

//public enum ValidationResult: Sendable {
//    case valid
//    case invalid(String)
//
//    public var isValid: Bool {
//        if case .valid = self { return true }
//        return false
//    }
//
//    public var errorMessage: String? {
//        if case .invalid(let message) = self { return message }
//        return nil
//    }
//}
