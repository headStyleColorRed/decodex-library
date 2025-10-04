//
//  ThreadingInfo.swift
//  decodex-cli
//
//  Created by Rodrigo Labrador Serrano on 6/9/25.
//

import Foundation

public struct ThreadingInfo {
    public let taskId: String?
    public let contextId: String?
    public let messageId: String?

    public init(taskId: String?, contextId: String?, messageId: String?) {
        self.taskId = taskId
        self.contextId = contextId
        self.messageId = messageId
    }

    /// Returns true if this info can be used for follow-up messages
    public var canContinueConversation: Bool {
        return taskId != nil
    }
}
