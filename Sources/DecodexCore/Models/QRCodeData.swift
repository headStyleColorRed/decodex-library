//
//  QRCodeData.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 7/9/25.
//

public struct QRCodeData: Codable {
    public let sid: String
    public let relayURL: String
    public let sessionKey: Base64
}
