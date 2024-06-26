//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/24/24.
//

import Foundation

enum AttributeValue: Equatable, ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }

    case string(String)
    case empty

    var string: String? {
        switch self {
        case .string(let str): str
        case .empty: nil
        }
    }
}

struct HTMLElement: Equatable {
    var name: String
    var attributes = [String: AttributeValue]()
    var contents: String?
    internal init(
        name: String,
        attributes: [String : AttributeValue] = [String: AttributeValue](),
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
