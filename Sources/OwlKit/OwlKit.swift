// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct OpenGraphService {
    public var metadata: (URL) async throws -> [OGIdentifier: NonEmptyContainer<OGMetadata>]

    public static func live() -> Self {
        let client = OpenGraphClient(networking: .live)
        return .init(metadata: { url in
            try await client.parse(url: url)
        })
    }
}
