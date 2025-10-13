//
//  DesktopRecord.swift
//  decodex-ios
//
//  Created by Rodrigo Labrador Serrano on 7/10/25.
//

import Foundation
import SwiftData

public enum ChannelType {
    case pairing, messaging
}

@Model
public final class DesktopRecord {
    public var id: String
    public var desktopDeviceId: String
    public var deskPub: String
    public var label: String?
    public var addedAt: Date
    public var lastSeenAt: Date
    public var state: String?
    public var pairingToken: String?

    
    public init(from qrData: PairingQRData) {
        self.id = UUID().uuidString
        self.desktopDeviceId = qrData.desktopID
        self.deskPub = qrData.desktopPublicKey
        self.label = qrData.desktopName
        self.addedAt = Date()
        self.lastSeenAt = Date()
        self.state = nil
        self.pairingToken = qrData.oneTimePairingToken
    }

    public func getUrl(for type: ChannelType) -> URL? {
        var url: String
        switch type {
        case .pairing:
            url = "/pair?device=\(desktopDeviceId)&token=\(deskPub)&role=\(ConnectionRole.desktop.rawValue)"
        case .messaging:
            url = "/ws?sid=\(id)&role=\(ConnectionRole.desktop.rawValue)"
        }

        return URL(string: url)
    }

    public var isConnected: Bool {
        return (state ?? "") == "paired" && lastSeenAt.timeIntervalSinceNow > -90 // 90 seconds threshold
    }

    public var connectionStatus: String {
        if isConnected {
            return "Connected"
        } else {
            return "Disconnected"
        }
    }
}
