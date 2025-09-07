# DecodexCore

A Swift library providing core models and protocols for the Decodex WebSocket relay system. This library defines the fundamental data structures and communication protocols used for secure, encrypted communication between desktop and controller applications.

## Features

- **Connection Management**: Define and manage connection roles (desktop/controller)
- **Message Framing**: Structured message envelopes with sequence numbers and encryption
- **Wire Protocol**: Complete protocol definition for WebSocket communication
- **Control Messages**: Built-in support for ping/pong, permissions, and session management
- **Type Safety**: Fully typed Swift models with Codable support
- **Concurrency Safe**: All models are marked as `Sendable` for safe concurrent usage

## Requirements

- Swift 6.0+
- macOS 13.0+ / iOS 16.0+

## Installation

### Swift Package Manager

Add DecodexCore to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/decodex-library.git", branch: "main")
]
```

Then add it to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["DecodexCore"]
    )
]
```

## Usage

### Connection Roles

```swift
import DecodexCore

// Define connection roles
let desktopRole = ConnectionRole.desktop
let controllerRole = ConnectionRole.controller

// Get opposite role for pairing
let oppositeRole = desktopRole.opposite // Returns .controller
```

### Message Envelopes

```swift
import DecodexCore

// Create a frame envelope
let envelope = FrameEnvelope(
    sid: UUID(),
    seq: 1,
    type: .data,
    bufferable: true,
    body: "base64EncodedData"
)

// Validate the envelope
let result = envelope.validate(for: sessionID)
if result.isValid {
    // Process the message
} else {
    print("Validation error: \(result.errorMessage ?? "Unknown error")")
}
```

### Wire Protocol

```swift
import DecodexCore

// Create control messages
let pingMessage = ControlMessage.ping
let statusMessage = ControlMessage.sessionStatus(
    SessionStatus(state: "connected", message: "Session established")
)

// Create wire protocol envelope
let wireEnvelope = Envelope(
    sid: "session-id",
    seq: 1,
    type: .control,
    buf: .text,
    body: "encryptedControlData"
)
```

### Processing Frames

```swift
import DecodexCore

// Handle frame processing results
switch frameProcessingResult {
case .success(let controlMessage):
    // Handle control message
    break
case .consoleData(let data):
    // Handle console data
    break
case .invalidSequence(let expected, let received):
    print("Sequence mismatch: expected \(expected), received \(received)")
case .cryptoError:
    print("Encryption/decryption failed")
case .malformedFrame:
    print("Frame format is invalid")
case .unknownMessageType:
    print("Unknown message type received")
}
```

## Architecture

### Core Models

- **`ConnectionRole`**: Defines desktop and controller connection types
- **`FrameEnvelope`**: Message framing with session ID, sequence numbers, and encryption
- **`Envelope`**: Wire protocol envelope for WebSocket communication
- **`ControlMessage`**: Typed control messages for session management

### Protocol Features

- **Session Management**: UUID-based session identification
- **Sequence Numbers**: Ordered message delivery with sequence validation
- **Encryption Support**: Base64-encoded encrypted message bodies
- **Buffer Types**: Support for both binary and text data
- **Error Handling**: Comprehensive error reporting and validation

## Development

### Building

```bash
make build
```

### Running

```bash
make run
```

### Testing

```bash
swift test
```

## License

[Add your license information here]

## Contributing

[Add contribution guidelines here]
