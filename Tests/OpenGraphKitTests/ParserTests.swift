//
//  ParserTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OpenGraphKit

final class ParserTests: XCTestCase {
    func testMetaTag() {
        let scanner = Parser(document: "<meta name=\"viewport\">")
        scanner.parse()
        print(scanner.elements, [
            Element(
                name: "meta",
                metadata: [
                    "name" : "\"viewport\""
                ]
            )
        ])
    }
}
