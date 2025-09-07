//
//  ResizeMessage.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 7/9/25.
//

import Foundation

struct ResizeMessage: Codable {
    let cols: UInt16
    let rows: UInt16
}
