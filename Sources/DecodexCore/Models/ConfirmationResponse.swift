//
//  ConfirmationResponse.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 29/9/25.
//

import Foundation

public struct ConfirmationResponse: Codable, Sendable {
    public let taskId: String
    public let callId: String
    public let outcome: ConfirmationOutcome

    public init(taskId: String, callId: String, outcome: ConfirmationOutcome) {
        self.taskId = taskId
        self.callId = callId
        self.outcome = outcome
    }
}

public enum ConfirmationOutcome: String, Codable, Sendable {
    case once = "proceed_once"
    case always = "proceed_always"
    case cancel = "cancel"
}
