//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import RegexBuilder
import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

class OpenGraphClient {
    struct Networking {
        var fetch: (URL) async throws -> (Data, URLResponse)

        static var live: Self {
            .init { url in
                try await URLSession.shared.data(from: url)
            }
        }

        internal init(fetch: @escaping (URL) async throws -> (Data, URLResponse)) {
            self.fetch = fetch
        }
    }

    var networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func parse(url: URL) async throws -> [OGIdentifier: NonEmptyContainer<OGMetadata>] {
        let (data, _) = try await networking.fetch(url)
        guard let document = String(data: data, encoding: .utf8) else { return [:] }

        let headMatch = document.firstMatch(of: OpenGraphClient.headRegex)
        guard let head = headMatch?.output.0 else { return [:] }

        return parse(document: String(head))
    }

    func parse(document: String) -> [OGIdentifier: NonEmptyContainer<OGMetadata>] {
        let parser = Parser(document: document)
        parser.parse()

        let metadataWithIdentifiers = parser.elements.compactMap { element -> (OGIdentifier, NonEmptyContainer<OGMetadata>)? in
            guard
                element.name == "meta",
                let property = element.metadata["property"],
                property.starts(with: "\"og:"),
                let content = element.metadata["content"]
            else { return nil }
            let metadata = OGMetadata.metadataFrom(property: property, content: content)
            return (metadata.name, [metadata])
        }

        return Dictionary(metadataWithIdentifiers, uniquingKeysWith: { lhs, rhs in lhs + rhs })
    }
}

extension OpenGraphClient {
    static var headRegex = Regex {
        One("<head>")
        Capture {
            OneOrMore(.any)
        }
        One("</head>")
    }

}
