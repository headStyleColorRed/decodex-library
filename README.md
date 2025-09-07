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
    .package(url: "https://github.com/headStyleColorRed/decodex-library.git", branch: "main")
]
```

Then add it to your target:

```swift
targets: [
    .executableTarget(
        name: "your-project", // Replace with your target name
        dependencies: [
            .product(name: "DecodexCore", package: "decodex-library")
        ],
        path: "Sources")
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
    bufferable: true,
    body: "base64EncodedData"
)

// Access envelope properties
print("Session ID: \(envelope.sid)")
print("Sequence: \(envelope.seq)")
print("Bufferable: \(envelope.bufferable)")
print("Body: \(envelope.body)")
```

### Control Messages

```swift
import DecodexCore

// Create control messages
let controlMessage = ControlMessage(dataB64: "base64EncodedControlData")

// Access control message data
print("Control data: \(controlMessage.dataB64)")
```

### Resize Messages

```swift
import DecodexCore

// Create resize messages for terminal resizing
let resizeMessage = ResizeMessage(cols: 80, rows: 24)

// Access resize properties
print("Columns: \(resizeMessage.cols)")
print("Rows: \(resizeMessage.rows)")
```

### Working with Base64 Data

```swift
import DecodexCore

// Base64 is a type alias for String
let base64Data: Base64 = "SGVsbG8gV29ybGQ="

// Use with frame envelopes
let envelope = FrameEnvelope(
    sid: UUID(),
    seq: 1,
    bufferable: true,
    body: base64Data
)

// Use with control messages
let controlMessage = ControlMessage(dataB64: base64Data)
```

## Architecture

### Core Models

- **`ConnectionRole`**: Enum defining desktop and controller connection types with opposite role functionality
- **`FrameEnvelope`**: Message framing structure with session ID (UUID), sequence numbers (UInt64), bufferable flag, and Base64 body
- **`ControlMessage`**: Simple control message structure containing Base64-encoded data
- **`ResizeMessage`**: Terminal resize message with columns and rows (UInt16)
- **`Base64`**: Type alias for String used for encoded data

### Protocol Features

- **Session Management**: UUID-based session identification
- **Sequence Numbers**: Ordered message delivery with UInt64 sequence numbers
- **Data Encoding**: Base64-encoded message bodies for secure transmission
- **Bufferable Messages**: Support for buffering messages when needed
- **Terminal Resizing**: Built-in support for terminal dimension changes
- **Type Safety**: All models conform to Codable and Sendable protocols

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
