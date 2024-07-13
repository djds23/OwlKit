// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public struct URLMetadata {
    public var openGraphMetadata: () -> [OGIdentifier: NonEmptyContainer<OGMetadata>]
    public var standardMetadata: () -> [StandardIdentifier: NonEmptyContainer<StandardMetadata>]
    public var summary: () -> Summary?
}

public struct Hoot {
    public var load: (URL) async throws -> URLMetadata

    public static func live(networking: Networking = .`default`) -> Self {
        .init(load: { url in
            let client = HootClient(networking: networking)
            let elements = try await client.parse(url: url)
            let openGraph = OpenGraphClient(htmlElements: elements)
            let standardMetadata = StandardMetadataClient(htmlElements: elements)
            return URLMetadata(
                openGraphMetadata: {
                    openGraph.parse()
                },
                standardMetadata: {
                    standardMetadata.parse()
                },
                summary: {
                    Summary.forURL(
                        url,
                        ogData: openGraph.parse(),
                        standard: standardMetadata.parse()
                    )
                }
            )
        })
    }
}
