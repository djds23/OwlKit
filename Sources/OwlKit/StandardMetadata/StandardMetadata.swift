//
//  StandardMetadata.swift
//  
//
//  Created by Dean Silfen on 7/13/24.
//


public struct StandardIdentifier: ExpressibleByStringLiteral, Equatable, RawRepresentable, Hashable {
    var identifier: String

    public var rawValue: String {
        identifier
    }

    public init(rawValue value: StringLiteralType) {
        identifier = value
    }

    public init(stringLiteral value: StringLiteralType) {
        identifier = value
    }
}

public struct StandardMetadata: Equatable {
    public var name: StandardIdentifier
    public var value: String
}

extension StandardMetadata {
    static func metadataFrom(name: String, content: String) -> Self? {
        switch name.withoutInnerStringQuotes {
        case "description":
            return .init(name: .description, value: content.withoutInnerStringQuotes)
        case "author":
            return .init(name: .author, value: content.withoutInnerStringQuotes)
        default:
            return nil
        }
    }
}
