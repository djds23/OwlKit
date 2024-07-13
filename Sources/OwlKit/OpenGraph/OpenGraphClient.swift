//
//  OpenGraphClient.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import RegexBuilder
import Foundation

class OpenGraphClient {
    private var htmlElements: [HTMLElement]
    private var output: [OGIdentifier: NonEmptyContainer<OGMetadata>]?
    init(htmlElements: [HTMLElement]) {
        self.htmlElements = htmlElements
    }

    func parse() -> [OGIdentifier: NonEmptyContainer<OGMetadata>] {
        if let output {
            return output
        }

        let metadataWithIdentifiers = htmlElements.compactMap { element -> (OGIdentifier, NonEmptyContainer<OGMetadata>)? in
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
        let output = Dictionary(metadataWithIdentifiers, uniquingKeysWith: { lhs, rhs in lhs + rhs })
        self.output = output
        return output
    }
}
