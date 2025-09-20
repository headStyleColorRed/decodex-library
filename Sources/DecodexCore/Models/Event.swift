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

public enum Model: String, CaseIterable, Codable {
    case gemini_2_5_pro = "gemini-2.5-pro"
    case gemini_2_5_flash = "gemini-2.5-flash"
    case gemini_2_5_flash_lite = "gemini-2.5-flash-lite"
    case gemini_2_0_pro = "gemini-2.0-pro"
    case gemini_2_0_flash = "gemini-2.0-flash"
    case gemini_1_5_pro = "gemini-1.5-pro"
    case gemini_1_5_flash = "gemini-1.5-flash"
}

public enum CLIOutputType: Equatable, Codable {
    case text(String)
}

public enum CLIEvent: Equatable, Codable {
    case none
    // Session
    case launching                          // Launching the llm process
    case authorizing                     	// Authorizing
    case loading(String)                   	// Loading
    case ready(Model)                      	// Session started, the llm is ready to process requests
    case disconnected                       // Disconnected from the llm process
    case currentDirectory(String)           // Current directory
    case contextLeft(Int)                   // Context left (goes from 100% to 0%)

    // Input
    case inputRequested(String)             // Model asks for more info (text/file/choice)
    case confirmationRequested([String])      // "Do you allow X?" / "Run tool Y?" gating

    // Output
    case output(CLIOutputType)            	// Model output
    case error(String)                      // Model error

    public static func == (lhs: CLIEvent, rhs: CLIEvent) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.launching, .launching):
            return true
        case (.authorizing, .authorizing):
            return true
        case (.loading(let lhsString), .loading(let rhsString)):
            return lhsString == rhsString
        case (.ready(let lhsModel), .ready(let rhsModel)):
            return lhsModel == rhsModel
        case (.disconnected, .disconnected):
            return true
        case (.currentDirectory(let lhsDir), .currentDirectory(let rhsDir)):
            return lhsDir == rhsDir
        case (.contextLeft(let lhsContext), .contextLeft(let rhsContext)):
            return lhsContext == rhsContext
        case (.inputRequested(let lhsText), .inputRequested(let rhsText)):
            return lhsText == rhsText
        case (.confirmationRequested(let lhsText), .confirmationRequested(let rhsText)):
            return lhsText == rhsText
        case (.output(let lhsOutput), .output(let rhsOutput)):
            return lhsOutput == rhsOutput
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

public enum ControlMessage: Codable {
    case message(String)
    case close
}

public enum SenderData: Codable {
    case controller(ControlMessage)
    case desktop(CLIEvent)
}

public struct Message: Codable {
    let data: SenderData
    
    var content: String? {
        switch data {
        case .controller(let message):
            switch message {
            case .message(let string):
                return string
            case .close:
                return nil
            }
        case .desktop(let event):
            switch event {
            case .none:
                return "None"
            case .launching:
                return "Launching"
            case .authorizing:
                return "Authorizing"
            case .loading(let string):
                return "Loading: \(string)"
            case .ready(let model):
                return "Ready: \(model)"
            case .disconnected:
                return "Disconnected"
            case .currentDirectory(let string):
                return "Current Directory: \(string)"
            case .contextLeft(let int):
                return "Context Left: \(int)"
            case .inputRequested(let string):
                return "Input Requested: \(string)"
            case .confirmationRequested(let array):
                return "Confirmation Requested: \(array)"
            case .output(let cLIOutputType):
                return "Output: \(cLIOutputType)"
            case .error(let string):
                return "Error: \(string)"
            }
        }
    }
}
