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


public enum CLIEvent: Equatable, Codable {
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

public enum ControlMessage: Codable, Sendable {
    case message(String)
    case confirmation(ConfirmationResponse)
    case pairResult(PairResult)
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
                return confirmation.outcome.rawValue
            case .pairResult(let result):
                return "pair-request"
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
            case .error(let string):
                return "Error: \(string)"
            case .loading(let string):
                return "Loading: \(string)"
            }
        }
    }
}
