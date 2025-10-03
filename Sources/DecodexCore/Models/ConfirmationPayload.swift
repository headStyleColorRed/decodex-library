//
//  File.swift
//  decodex-cli
//
//  Created by Rodrigo Labrador Serrano on 28/9/25.
//

import Foundation

public struct ConfirmationPayload: Codable {
    public enum Kind: String, Codable { case exec, edit }
    public let kind: Kind
    public let title: String
    public let details: [String : String]
    public let callId: String?

    public init(kind: Kind, title: String, details: [String : String], callId: String? = nil) {
        self.kind = kind
        self.title = title
        self.details = details
        self.callId = callId
    }
}

