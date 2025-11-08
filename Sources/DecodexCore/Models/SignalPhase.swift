//
//  SignalPhase.swift
//  decodex-cli
//
//  Created by Rodrigo Labrador Serrano on 28/9/25.
//

import Foundation

public enum SignalPhase: String, Codable, Sendable {
    case ready
    case thinking
    case answer
    case needInput
    case error
    case none
}
