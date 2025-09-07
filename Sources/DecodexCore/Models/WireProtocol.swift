import Foundation

// MARK: - Wire Protocol Envelope
public struct Envelope: Codable, Sendable {
    public let sid: String
    public let seq: UInt64
    public let type: MessageType
    public let buf: BufferType
    public let body: String // base64 encoded encrypted data

    public enum MessageType: String, Codable, Sendable {
        case data = "data"
        case control = "control"
    }

    public enum BufferType: Int, Codable, Sendable {
        case binary = 0
        case text = 1
    }

    public init(sid: String, seq: UInt64, type: MessageType, buf: BufferType, body: String) {
        self.sid = sid
        self.seq = seq
        self.type = type
        self.buf = buf
        self.body = body
    }
}
