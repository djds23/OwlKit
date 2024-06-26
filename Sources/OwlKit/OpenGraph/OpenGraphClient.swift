//
//  OpenGraphClient.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import RegexBuilder
import Foundation

class OpenGraphClient {
    var networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func parse(url: URL) async throws -> [OGIdentifier: NonEmptyContainer<OGMetadata>] {
        let (data, _) = try await networking.fetch(url)
        guard let document = String(data: data, encoding: .utf8) else { return [:] }

        let headRegex = Regex {
            One("<head>")
            Capture {
                OneOrMore(.any)
            }
            One("</head>")
        }

        let headMatch = document.firstMatch(of: headRegex)
        guard let head = headMatch?.output.0 else { return [:] }

        return parse(document: String(head))
    }

    func parse(document: String) -> [OGIdentifier: NonEmptyContainer<OGMetadata>] {
        let parser = Parser(document: document)
        parser.parse()

        let metadataWithIdentifiers = parser.elements.compactMap { element -> (OGIdentifier, NonEmptyContainer<OGMetadata>)? in
            guard
                element.name == "meta",
                let propertyValue = element.attributes["property"],
                let property = propertyValue.string,
                property.starts(with: "\"og:"),
                let contentValue = element.attributes["content"],
                let content = contentValue.string
            else { return nil }
            let metadata = OGMetadata.metadataFrom(property: property, content: content)
            return (metadata.name, [metadata])
        }

        return Dictionary(metadataWithIdentifiers, uniquingKeysWith: { lhs, rhs in lhs + rhs })
    }
}
