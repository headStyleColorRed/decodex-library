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

// MARK: - Control Messages
public enum ControlMessage: Codable, Sendable {
    case hello
    case ping
    case pong
    case permissionRequest(PermissionRequest)
    case permissionReply(PermissionReply)
    case sessionStatus(SessionStatus)
    case error(ErrorMessage)

    enum CodingKeys: String, CodingKey {
        case type
        case payload
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "hello":
            self = .hello
        case "ping":
            self = .ping
        case "pong":
            self = .pong
        case "permission_request":
            let request = try container.decode(PermissionRequest.self, forKey: .payload)
            self = .permissionRequest(request)
        case "permission_reply":
            let reply = try container.decode(PermissionReply.self, forKey: .payload)
            self = .permissionReply(reply)
        case "session_status":
            let status = try container.decode(SessionStatus.self, forKey: .payload)
            self = .sessionStatus(status)
        case "error":
            let error = try container.decode(ErrorMessage.self, forKey: .payload)
            self = .error(error)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown message type: \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .hello:
            try container.encode("hello", forKey: .type)
        case .ping:
            try container.encode("ping", forKey: .type)
        case .pong:
            try container.encode("pong", forKey: .type)
        case .permissionRequest(let request):
            try container.encode("permission_request", forKey: .type)
            try container.encode(request, forKey: .payload)
        case .permissionReply(let reply):
            try container.encode("permission_reply", forKey: .type)
            try container.encode(reply, forKey: .payload)
        case .sessionStatus(let status):
            try container.encode("session_status", forKey: .type)
            try container.encode(status, forKey: .payload)
        case .error(let error):
            try container.encode("error", forKey: .type)
            try container.encode(error, forKey: .payload)
        }
    }
}

// MARK: - Session Status
public struct SessionStatus: Codable, Sendable {
    public let state: String
    public let message: String?
    public let timestamp: Date

    public init(state: String, message: String? = nil) {
        self.state = state
        self.message = message
        self.timestamp = Date()
    }
}

// MARK: - Error Message
public struct ErrorMessage: Codable, Sendable {
    public let code: String
    public let message: String
    public let details: [String: String]?

    public init(code: String, message: String, details: [String: String]? = nil) {
        self.code = code
        self.message = message
        self.details = details
    }
}

// MARK: - Frame Processing Result
public enum FrameProcessingResult: Sendable {
    case success(ControlMessage)
    case consoleData(Data)
    case invalidSequence(expected: UInt64, received: UInt64)
    case cryptoError
    case malformedFrame
    case unknownMessageType
}