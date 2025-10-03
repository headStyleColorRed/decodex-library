//
//  CLIEvent.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 8/9/25.
//

import Foundation

public enum Loading {
    case started
    /// Progress messured in seconds
    case inProgress(Int)
    case completed
}

public enum Model: String, CaseIterable, Codable, Sendable {
    case gemini_2_5_pro = "gemini-2.5-pro"
    case gemini_2_5_flash = "gemini-2.5-flash"
    case gemini_2_5_flash_lite = "gemini-2.5-flash-lite"
}

public enum CLIOutputType: Equatable, Codable {
    case text(String)
}

public enum CLIEvent: Equatable, Codable {
    case none
    // Session
    case launching                          // Launching the llm process
    case authorizing                     	// Authorizing
    case event(SSESignal)                   	// Event
    case disconnected                       // Disconnected from the llm process
    case currentDirectory(String)           // Current directory
    case contextLeft(Int)                   // Context left (goes from 100% to 0%)
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
        case (.event(let lhsDvent), .event(let rhsDvent)):
            return true
        case (.currentDirectory(let lhsDir), .currentDirectory(let rhsDir)):
            return lhsDir == rhsDir
        case (.contextLeft(let lhsContext), .contextLeft(let rhsContext)):
            return lhsContext == rhsContext
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

public enum ControlMessage: Codable {
    case message(String)
    case confirmation(ConfirmationResponse)
    case close
}

public enum SenderData: Codable {
    case controller(ControlMessage)
    case desktop(CLIEvent)
}

public struct Message: Codable {
    public let data: SenderData

    public init(data: SenderData) {
        self.data = data
    }

    public var content: String? {
        switch data {
        case .controller(let message):
            switch message {
            case .message(let string):
                return string
            case .close:
                return nil
            case .confirmation(let confirmation):
                return confirmation.outcome
            }
        case .desktop(let event):
            switch event {
            case .none:
                return "None"
            case .launching:
                return "Launching"
            case .authorizing:
                return "Authorizing"
            case .event(let event):
                return "Event: \(event)"
            case .disconnected:
                return "Disconnected"
            case .currentDirectory(let string):
                return "Current Directory: \(string)"
            case .contextLeft(let int):
                return "Context Left: \(int)"
            case .error(let string):
                return "Error: \(string)"
            }
        }
    }
}
