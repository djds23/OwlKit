//
//  ParserTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OwlKit

final class ParserTests: XCTestCase {
    func testMetaTag() {
        let scanner = Parser(document: "<meta name=\"viewport\">")
        scanner.parse()
        print(scanner.elements, [
            HTMLElement(
                name: "meta",
                metadata: [
                    "name" : "\"viewport\""
                ]
            )
        ])
    }
}
