//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import RegexBuilder
import Foundation

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

    func parse(url: URL) async throws -> [OGMetadata] {
        let (data, _) = try await networking.fetch(url)
        guard let document = String(data: data, encoding: .utf8) else { return [] }

        let headMatch = document.firstMatch(of: OpenGraphClient.headRegex)
        guard let head = headMatch?.output.0 else { return [] }

        return parse(document: String(head))
    }

    func parse(document: String) -> [OGMetadata] {
        let parser = Parser(document: document)
        parser.parse()

        return parser.elements.compactMap { element -> OGMetadata? in
            guard
                element.name == "meta",
                let property = element.metadata["property"],
                property.starts(with: "\"og:"),
                let content = element.metadata["content"]
            else { return nil }
            return .metadataFrom(property: property, content: content)
        }
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
