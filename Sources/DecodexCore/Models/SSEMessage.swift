//
//  SSEMessage.swift
//  decodex-cli
//
//  Created by Rodrigo Labrador Serrano on 28/9/25.
//

import Foundation
import ObjectMapper
import DecodexCore

public struct SSEMessage: Mappable {
    public var messageId: String?
    public var parts: [Part] = []

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        messageId <- map["messageId"]

        // Map a few parts defensively
        if let p0 = Part.from(map: map, idx: 0) { parts.append(p0) }
        if let p1 = Part.from(map: map, idx: 1) { parts.append(p1) }
        if let p2 = Part.from(map: map, idx: 2) { parts.append(p2) }
    }

    // Concatenate all text parts (e.g., "Hello" + "! How can I help…")
    public var joinedText: String? {
        let texts = parts.compactMap { if case let .text(t) = $0 { return t } else { return nil } }
        return texts.isEmpty ? nil : texts.joined()
    }

    // Extract a tiny confirmation payload if present
    public var asConfirmation: ConfirmationPayload? {
        guard case let .confirmation(kind, title, details, callId) = parts.first(where: {
            if case .confirmation = $0 { return true } else { return false }
        }) else { return nil }

        switch kind {
        case .exec:
            return ConfirmationPayload(kind: .exec, title: title, details: details, callId: callId)
        case .edit:
            return ConfirmationPayload(kind: .edit, title: title, details: details, callId: callId)
        }
    }

    public enum Part {
        case text(String)
        case confirmation(ConfirmationKind, String, [String:String], String?)

        public enum ConfirmationKind { case exec, edit }

        public static func from(map: Map, idx: Int) -> Part? {
            var kind: String?
            kind <- map["parts.\(idx).kind"]

            switch kind {
            case "text":
                var txt: String?
                txt <- map["parts.\(idx).text"]
                return txt.map(Part.text)

            case "data":
                // Only care about awaiting_approval confirmation details
                var status: String?
                status <- map["parts.\(idx).data.status"]
                guard status == "awaiting_approval" else { return nil }

                var type: String?
                type <- map["parts.\(idx).data.confirmationDetails.type"]

                // Exec confirmation
                if type == "exec" {
                    var title, command, root, callId: String?
                    title  <- map["parts.\(idx).data.confirmationDetails.title"]
                    command <- map["parts.\(idx).data.confirmationDetails.command"]
                    root    <- map["parts.\(idx).data.confirmationDetails.rootCommand"]
                    callId  <- map["parts.\(idx).data.request.callId"]
                    let details: [String:String] = [
                        "command": command ?? "",
                        "rootCommand": root ?? ""
                    ]
                    return .confirmation(.exec, title ?? "Confirm command", details, callId)
                }

                // Edit confirmation
                if type == "edit" {
                    var title, fileName, filePath, diff, callId: String?
                    title    <- map["parts.\(idx).data.confirmationDetails.title"]
                    fileName <- map["parts.\(idx).data.confirmationDetails.fileName"]
                    filePath <- map["parts.\(idx).data.confirmationDetails.filePath"]
                    diff     <- map["parts.\(idx).data.confirmationDetails.fileDiff"]
                    callId   <- map["parts.\(idx).data.request.callId"]
                    let details: [String:String] = [
                        "fileName": fileName ?? "",
                        "filePath": filePath ?? "",
                        "diff": diff ?? ""
                    ]
                    return .confirmation(.edit, title ?? "Confirm change", details, callId)
                }
                return nil

            default:
                return nil
            }
        }
    }
}
