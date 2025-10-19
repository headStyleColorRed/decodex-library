//
//  ConnectionStatus.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 8/9/25.
//

public enum ConnectionStatus: Sendable {
    case disconnected(Error? = nil), connecting, connected, paired
}
