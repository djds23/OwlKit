//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/19/24.
//

import Foundation

public enum OGValue: Equatable {
    case url(URL)
    case string(String)
    case integer(Int)
    case float(Double)
    case enumeration(Set<String>)
    case datetime(Date)
    case bool(Bool)

    public var string: String? {
        switch self {
        case let .string(s):
            return s
        default:
            return nil
        }
    }

    public var url: URL? {
        switch self {
        case let .url(url):
            return url
        default:
            return nil
        }
    }

    public var integer: Int? {
        switch self {
        case let .integer(integer):
            return integer
        default:
            return nil
        }
    }


    public var float: Double? {
        switch self {
        case let .float(double):
            return double
        default:
            return nil
        }
    }
}

public struct OGIdentifier: ExpressibleByStringLiteral, Equatable, RawRepresentable, Hashable {
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

public struct OGMetadata: Equatable {
    public var name: OGIdentifier
    public var value: OGValue

    public init(name: OGIdentifier, value: OGValue) {
        self.name = name
        self.value = value
    }

    static func stringType(name: OGIdentifier, rawValue: String) -> Self {
        .init(
            name: name,
            value: .string(rawValue)
        )
    }

    static func urlType(name: OGIdentifier, rawValue: String) -> Self? {
        guard
            let url = URL(string: rawValue)
        else { return nil }

        return .init(
            name: name,
            value: .url(url)
        )
    }

    static func numericType(name: OGIdentifier, rawValue: String) -> Self? {
        if rawValue.contains("(.|e|E)"), let doubleValue = Double(rawValue) {
            return .init(name: name, value: .float(doubleValue))
        } else if let intValue = Int(rawValue) {
            return .init(name: name, value: .integer(intValue))
        } else {
            return nil
        }
    }

    static func metadataFrom(property: String, content: String) -> Self {
        let trimmedProperty = OGIdentifier(rawValue: property.withoutInnerStringQuotes)
        let trimmedContent = content.withoutInnerStringQuotes

        let output: OGMetadata? = switch trimmedProperty {
        case "og:url", "og:image":
            .urlType(name: trimmedProperty, rawValue: trimmedContent)
        case "og:image:height", "og:image:width":
            .numericType(name: trimmedProperty, rawValue: trimmedContent)
        default:
            .stringType(name: trimmedProperty, rawValue: trimmedContent)
        }
        return output ?? .stringType(name: trimmedProperty, rawValue: trimmedContent)
    }
}
