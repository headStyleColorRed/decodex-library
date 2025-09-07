//
//  QRCodeData.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 7/9/25.
//

struct QRCodeData: Codable {
    let sid: String
    let relayURL: String
    let sessionKey: Base64
}
