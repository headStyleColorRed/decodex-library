//
//  ConfirmationResponse.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 29/9/25.
//

import Foundation

public struct ConfirmationResponse: Codable, Sendable {
    public let callId: String
    public let outcome: ConfirmationOutcome

    public init(callId: String, outcome: ConfirmationOutcome) {
        self.callId = callId
        self.outcome = outcome
    }
}

public enum ConfirmationOutcome: String, Codable, Sendable {
    case once = "proceed_once"
    case always = "proceed_always"
    case cancel = "cancel"
}
