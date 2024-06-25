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
        let parser = Parser(document: "<meta name=\"viewport\">")
        parser.parse()
        XCTAssertEqual(parser.elements, [
            HTMLElement(
                name: "meta",
                metadata: [
                    "name" : "\"viewport\""
                ]
            )
        ])
    }

    func testElementWithAttributesAndNoContent() {
        let parser = Parser(document: "<script src=\"js/app.js\"></script>")
        parser.parse()
        XCTAssertEqual(parser.elements, [
            HTMLElement(
                name: "script",
                metadata: [
                    "src" : "\"js/app.js\""
                ]
            )
        ])
    }

    func testElementWithContentAndAttributes() {
        let parser = Parser(document: "<p style=\"color:green\">This is a paragraph.</p>")
        parser.parse()
        XCTAssertEqual(parser.elements, [
            HTMLElement(
                name: "p",
                metadata: ["style": "\"color:green\""],
                contents: "This is a paragraph."
            )
        ])
    }
}
