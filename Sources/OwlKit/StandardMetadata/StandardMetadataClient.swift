//
//  StandardMetadataClient.swift
//  
//
//  Created by Dean Silfen on 7/12/24.
//

// A metadata client that parses standard meta tags
// https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta/name
class StandardMetadataClient {
    private var htmlElements: [HTMLElement]

    init(htmlElements: [HTMLElement]) {
        self.htmlElements = htmlElements
    }
    var output: [StandardIdentifier: NonEmptyContainer<StandardMetadata>]?
    func parse() -> [StandardIdentifier: NonEmptyContainer<StandardMetadata>] {
        if let output {
            return output
        }

        let metadataWithIdentifiers = htmlElements.compactMap { element -> (StandardIdentifier, NonEmptyContainer<StandardMetadata>)? in
            if element.name == "title",
                let contents = element.contents {
                return (
                    StandardIdentifier.title,
                    [StandardMetadata(name: .title, value: contents)]
                )
            } else {
                guard
                    element.name == "meta",
                    let nameValue = element.attributes["name"],
                    let name = nameValue.string,
                    let contentValue = element.attributes["content"],
                    let content = contentValue.string,
                    let metadata = StandardMetadata.metadataFrom(name: name, content: content)
                else { return nil }
                return (metadata.name, [metadata])
            }
        }
        let output = Dictionary(metadataWithIdentifiers, uniquingKeysWith: { lhs, rhs in lhs + rhs })
        self.output = output
        return output
    }
}


