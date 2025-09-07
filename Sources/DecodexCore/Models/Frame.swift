import Foundation

/// Message framing structure for relayed messages
public struct Frame: Codable, Sendable {
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
}
