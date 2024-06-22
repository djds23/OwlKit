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
}

public struct OGMetadata: Equatable {
    public var name: String
    public var value: OGValue

    public init(name: String, value: OGValue) {
        self.name = name
        self.value = value
    }

    static func stringType(name: String, rawValue: String) -> Self {
        .init(
            name: name,
            value: .string(rawValue)
        )
    }

    static func urlType(name: String, rawValue: String) -> Self? {
        guard
            let url = URL(string: rawValue)
        else { return nil }

        return .init(
            name: name,
            value: .url(url)
        )
    }

    static func numericType(name: String, rawValue: String) -> Self? {
        if rawValue.contains("(.|e|E)"), let doubleValue = Double(rawValue) {
            return .init(name: name, value: .float(doubleValue))
        } else if let intValue = Int(rawValue) {
            return .init(name: name, value: .integer(intValue))
        } else {
            return nil
        }
    }

    static func metadataFrom(property: String, content: String) -> Self {
        let trimmedProperty = property.withoutInnerStringQuotes
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
