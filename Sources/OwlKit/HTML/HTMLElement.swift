//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/24/24.
//

import Foundation

public enum AttributeValue: Equatable, ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }

    /// Support for attributes which provide a string
    case string(String)

    /// Support for attributes which only provide an identifier with no corseponding value.
    /// For example `required` for `<input>`.
    case empty

    public var string: String? {
        switch self {
        case .string(let str): str
        case .empty: nil
        }
    }
}

public struct HTMLElement: Equatable {
    public var name: String
    public var attributes = [String: AttributeValue]()
    public var contents: String?
    public init(
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
