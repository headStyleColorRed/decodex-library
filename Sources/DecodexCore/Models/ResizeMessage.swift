//
//  ResizeMessage.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 7/9/25.
//

import Foundation

public struct ResizeMessage: Codable {
    public let cols: UInt16
    public let rows: UInt16
}
