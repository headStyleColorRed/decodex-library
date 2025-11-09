//
//  CLIEvent.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 8/9/25.
//

import Foundation

public enum Model: String, CaseIterable, Codable, Sendable {
    case gemini_2_5_pro = "gemini-2.5-pro"
    case gemini_2_5_flash = "gemini-2.5-flash"
    case gemini_2_5_flash_lite = "gemini-2.5-flash-lite"
}


public enum CLIEvent: Equatable, Codable, Sendable {
    case none
    case loading(String)                    // Loading
    case launching                          // Launching the llm process
    case authorizing                     	// Authorizing
    case event(SSESignal)                   // Event
    case disconnected                       // Disconnected from the llm process
    case currentDirectory(String)           // Current directory
    case error(String)                      // Model error

    public static func == (lhs: CLIEvent, rhs: CLIEvent) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.launching, .launching):
            return true
        case (.authorizing, .authorizing):
            return true
        case (.disconnected, .disconnected):
            return true
        case (.event(_), .event(_)):
            return true
        case (.currentDirectory(let lhsDir), .currentDirectory(let rhsDir)):
            return lhsDir == rhsDir
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

public struct ControlMessage: Codable, Sendable {
    public let taskId: String?
    public let message: String

    public init(taskId: String? = nil, message: String) {
        self.taskId = taskId
        self.message = message
    }
}

public enum ControlEvent: Codable, Sendable {
    case message(ControlMessage)
    case confirmation(ConfirmationResponse)
    case close
}

public enum ServerEvent: Codable, Sendable {
    case connected(ConnectionRole)
    case sessionExpired
    case error(String)
}

public enum SenderData: Codable, Sendable {
    case controller(ControlEvent)
    case desktop(CLIEvent)
    case server(ServerEvent)
}

public struct Message: Codable, Sendable {
    public let data: SenderData

    public init(data: SenderData) {
        self.data = data
    }
}
