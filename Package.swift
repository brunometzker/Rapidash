// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Rapidash",
    products: [
        .library(name: "Rapidash", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // ⚡️Non-blocking, event-driven Redis client.
        .package(url: "https://github.com/vapor/redis.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Redis", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
