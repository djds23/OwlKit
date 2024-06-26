//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/24/24.
//

import Foundation

struct HTMLElement: Equatable {
    var name: String
    var attributes = [String: String]()
    var contents: String?
    internal init(
        name: String,
        attributes: [String : String] = [String: String](),
        contents: String? = nil
    ) {
        self.name = name
        self.attributes = attributes
        self.contents = contents
    }
}

extension HTMLElement {
    var isVoidElement: Bool {
        Self.voidElements.contains(name.lowercased())
    }

    static let voidElements: Set<String> = [
        "area",
        "base",
        "br",
        "col",
        "command",
        "embed",
        "hr",
        "img",
        "input",
        "keygen",
        "link",
        "meta",
        "param",
        "source",
        "track",
        "wbr"
    ]
}