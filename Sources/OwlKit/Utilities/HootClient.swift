//
//  HootClient.swift
//  
//
//  Created by Dean Silfen on 7/13/24.
//

import Foundation
import RegexBuilder
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class HootClient {
    var networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func parse(url: URL) async throws -> [HTMLElement] {
        let (data, _) = try await networking.fetch(url)
        guard let document = String(data: data, encoding: .utf8) else { return [] }

        let headRegex = Regex {
            One("<head>")
            Capture {
                OneOrMore(.any)
            }
            One("</head>")
        }

        let headMatch = document.firstMatch(of: headRegex)
        guard let head = headMatch?.output.0 else { return [] }

        return parse(document: String(head))
    }

    func parse(document: String) -> [HTMLElement] {
        let parser = Parser(document: document)
        parser.parse()
        return parser.elements
    }

}
