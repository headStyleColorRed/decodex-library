//
//  WebSocketManager.swift
//  decodex-library
//
//  Created by Rodrigo Labrador Serrano on 8/9/25.
//

import Foundation
import WebSocketKit
import NIOCore
import NIOPosix

protocol WebSocketManagerDelegate {
    func onMessageReceived(_ message: String)
    func onBinaryMessageReceived(_ message: Data)
    func onDisconnected()
}

@MainActor
class WebSocketManager: ObservableObject {
    @Published var connectionStatus: ConnectionStatus

    private var webSocket: WebSocket?
    private var eventLoopGroup: EventLoopGroup?
    private let config: WebSocketConfig
    private let qrCodeData: QRCodeData


    var delegate: WebSocketManagerDelegate?

    init(config: WebSocketConfig, qrCodeData: QRCodeData) {
        self.config = config
        self.qrCodeData = qrCodeData
        self.connectionStatus = .disconnected
    }

    func connect() async {
        guard connectionStatus == .disconnected else { return }

        connectionStatus = .connecting

        // Create event loop group
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let eventLoop = eventLoopGroup!.next()

        // Build WebSocket URL using configuration
        let urlString = config.endpoint(data: qrCodeData)

        guard let url = URL(string: urlString) else {
            connectionStatus = .disconnected
            return
        }

        let promise = eventLoop.makePromise(of: WebSocket.self)

        WebSocket.connect(to: url, on: eventLoop) { ws in
            promise.succeed(ws)
        }.whenFailure { error in
            promise.fail(error)
        }

        do {
            let ws = try await promise.futureResult.get()
            webSocket = ws
            connectionStatus = .connected
            print("Connected to Decodex server with session: \(qrCodeData.sid)")
            handleConnection(ws)
        } catch {
            print("Failed to connect: \(error)")
            connectionStatus = .disconnected
            await disconnect()
        }
    }

    func disconnect() async {
        guard let ws = webSocket else { return }

        do {
            try await ws.close()
        } catch {
            print("Error closing WebSocket: \(error)")
        }

        webSocket = nil
        connectionStatus = .disconnected

        // Shutdown event loop group
        try? await eventLoopGroup?.shutdownGracefully()
        eventLoopGroup = nil

        print("Disconnected from Decodex server")
    }

    private func handleConnection(_ ws: WebSocket) {
        // Handle incoming messages
        ws.onText { [weak self] _, text in
            Task { @MainActor in
                print("Received text message: \(text)")
                self?.delegate?.onMessageReceived(text)
            }
        }

        ws.onBinary { [weak self] _, data in
            Task { @MainActor in
                print("Received binary message: \(data.readableBytes) bytes")
                // Convert ByteBuffer to Data
                let messageData = Data(buffer: data)
                self?.delegate?.onBinaryMessageReceived(messageData)
            }
        }

        ws.onClose.whenComplete { [weak self] result in
            Task { @MainActor in
                self?.connectionStatus = .disconnected
                print("WebSocket connection closed")
                self?.delegate?.onDisconnected()
            }
        }
    }

    // MARK: - Sending Messages
    func sendMessage(_ data: Data) {
        guard let ws = webSocket, connectionStatus != .disconnected else {
            print("Not connected to server")
            return
        }

        // Convert Data to ByteBuffer
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)

        // Send as binary data
        ws.send(buffer)
        print("Message sent successfully")
    }
}
