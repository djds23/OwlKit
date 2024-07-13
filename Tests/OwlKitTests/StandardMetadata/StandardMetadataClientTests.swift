//
//  Test.swift
//  
//
//  Created by Dean Silfen on 7/13/24.
//
import XCTest
@testable import OwlKit

final class StandardMetadataClientTests: XCTestCase {

    func testExtractingTitle() async throws {
        let client = StandardMetadataClient(
            htmlElements: [
                HTMLElement(
                    name: "title",
                    attributes: [:],
                    contents: "This is a webpage"
                )
            ]
        )
        let metadata = client.parse()

        XCTAssertEqual(metadata, [.title: [.init(name: .title, value: "This is a webpage")]])
    }
    
    func testMetaContent() async throws {
        let client = StandardMetadataClient(
            htmlElements: [
                HTMLElement(
                    name: "meta",
                    attributes: [
                        "name": "author",
                        "content": "\"Me, I am the one who made this.\""
                    ]
                )
            ]
        )
        let metadata = client.parse()

        XCTAssertEqual(metadata, [.author: [.init(name: .author, value: "Me, I am the one who made this.")]])
    }
}
