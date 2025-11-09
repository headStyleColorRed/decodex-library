//
//  SSESignal.swift
//  decodex-cli
//
//  Created by Rodrigo Labrador Serrano on 28/9/25.
//

import Foundation

public struct SSESignal: Codable, Sendable {
    public let phase: SignalPhase
    public let text: String?
    public let confirmation: ConfirmationPayload?
    public let taskId: String?
    public let contextId: String?
    public let messageId: String?
    public let callId: String?
    public let final: Bool
    public let requiresUserAction: Bool

    public init(phase: SignalPhase,
                text: String? = nil,
                confirmation: ConfirmationPayload? = nil,
                taskId: String? = nil,
                contextId: String? = nil,
                messageId: String? = nil,
                callId: String? = nil,
                final: Bool = false,
                requiresUserAction: Bool = false) {
        self.phase = phase
        self.text = text
        self.confirmation = confirmation
        self.taskId = taskId
        self.contextId = contextId
        self.messageId = messageId
        self.callId = callId
        self.final = final
        self.requiresUserAction = requiresUserAction
    }
}
