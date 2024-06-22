// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

struct OpenGraphService {
    var metadata: (URL) async throws -> [OGMetadata]

    static func live() -> Self {
        let client = OpenGraphClient(networking: .live)
        return .init(metadata: { url in
            try await client.parse(url: url)
        })
    }
}
