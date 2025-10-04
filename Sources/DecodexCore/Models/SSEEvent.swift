//
//  SSEEvent.swift
//  decodex-cli
//
//  Created by Rodrigo Labrador Serrano on 28/9/25.
//

import Foundation
import ObjectMapper

public struct SSEEvent: Mappable {
    // External
    public var id: String?
    public var event: String?
    public var kind: Kind?
    public var taskId: String?
    public var contextId: String?

    // Status
    public var state: StatusState?
    public var final: Bool
    public var message: SSEMessage?

    public var asThreadInfo: ThreadingInfo {
        return ThreadingInfo(taskId: taskId,
                             contextId: contextId,
                             messageId: message?.messageId)
    }

    public var responseIsFinished: Bool {
        return final == true
    }

    public var isWaitingForInput: Bool {
        return responseIsFinished == false && asSignal.phase == .needInput
    }

    public enum Kind: String {
        case task = "task"
        case statusUpdate = "status-update"
    }

    public enum StatusState: String {
        case submitted       = "submitted"
        case working         = "working"
        case inputRequired   = "input-required"
        case error           = "error"
    }

    public init?(map: Map) {
        final = false
    }

    public mutating func mapping(map: Map) {
        kind        <- map["result.kind"]
        taskId      <- map["result.taskId"]
        contextId   <- map["result.contextId"]
        state       <- map["result.status.state"]
        final       <- map["result.final"]
        message     <- map["result.status.message"]
    }

    public mutating func setID(_ id: String) {
        self.id = id
    }

    public mutating func setEvent(_ event: String) {
        self.event = event
    }

    public var asSignal: SSESignal {
        switch kind {
        case .task:
            // New task acknowledged by Gemini
            return SSESignal(phase: .ready,
                             taskId: taskId,
                             contextId: contextId,
                             final: final)
        case .statusUpdate:
            guard let state else {
                return SSESignal(phase: .none,
                                 taskId: taskId,
                                 contextId: contextId,
                                 messageId: message?.messageId,
                                 final: final)
            }

            switch state {
            case .submitted:
                return SSESignal(phase: .ready,
                                 taskId: taskId,
                                 contextId: contextId,
                                 messageId: message?.messageId,
                                 final: final)
            case .working:
                // If we have user-visible text, surface it; otherwise say "thinking"
                if let response = message?.joinedText {
                    return SSESignal(phase: .answer,
                                     text: response,
                                     taskId: taskId,
                                     contextId: contextId,
                                     messageId: message?.messageId,
                                     final: final)
                }

                // If this "working" carries an approval request, surface needInput
                if let confirm = message?.asConfirmation {
                    return SSESignal(phase: .needInput,
                                     confirmation: confirm,
                                     taskId: taskId,
                                     contextId: contextId,
                                     messageId: message?.messageId,
                                     callId: confirm.callId,
                                     final: final,
                                     requiresUserAction: true)
                }

                // Otherwise it's tool/thought/state churn → just "thinking"
                return SSESignal(phase: .thinking,
                                 taskId: taskId,
                                 contextId: contextId,
                                 messageId: message?.messageId,
                                 final: final)

            case .inputRequired:
                // Generic "waiting for approval…" when no payload provided
                return SSESignal(phase: .needInput,
                                 confirmation: message?.asConfirmation,
                                 taskId: taskId,
                                 contextId: contextId,
                                 messageId: message?.messageId,
                                 callId: message?.asConfirmation?.callId,
                                 final: final,
                                 requiresUserAction: true)

            case .error:
                let errText = message?.joinedText ?? "Agent reported an error."
                return SSESignal(phase: .error,
                                 text: errText,
                                 taskId: taskId,
                                 contextId: contextId,
                                 messageId: message?.messageId,
                                 final: final)
            }

        case .none:
            return SSESignal(phase: .none,
                             taskId: taskId,
                             contextId: contextId,
                             messageId: message?.messageId,
                             final: final)
        }
    }
}
