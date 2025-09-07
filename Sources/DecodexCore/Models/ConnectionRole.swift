import Foundation

/// Represents the role of a WebSocket connection
public enum ConnectionRole: String, CaseIterable, Codable, Sendable {
    case desktop = "desktop"
    case controller = "controller"

    public init?(_ string: String?) {
        guard let string = string else { return nil }
        self.init(rawValue: string)
    }

    /// Returns the opposite role for pairing
    public var opposite: ConnectionRole {
        switch self {
        case .desktop:
            return .controller
        case .controller:
            return .desktop
        }
    }
}