//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/19/24.
//

import Foundation

struct OpenGraph {
    var load: (URL) async -> [String]
}

class OpenGraphClient {
    init() {

    }

    func parse(document: String) -> [Element] {
        let parser = Parser(document: document)
        parser.parse()

        return parser.elements.compactMap { element in
            print(element)
            guard
                element.name == "meta",
                let property = element.metadata["property"],
                (property?.starts(with: "\"og:") ?? false),
                let _ = element.metadata["content"]
            else { return nil }
            return element
        }
    }
}
