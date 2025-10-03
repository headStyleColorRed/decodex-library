//
//  ConfirmationResponse.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 29/9/25.
//

import Foundation

public struct ConfirmationResponse: Codable, Sendable {
    public let callId: String
    public let outcome: String

    public init(callId: String, outcome: String) {
        self.callId = callId
        self.outcome = outcome
    }
}
