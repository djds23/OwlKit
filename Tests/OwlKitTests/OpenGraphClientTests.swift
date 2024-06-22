//
//  OpenGraphClientTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OwlKit

final class OpenGraphClientTests: XCTestCase {

    func testExample() throws {
        let client = OpenGraphClient()
        let elements = client.parse(document: htmlText)
        XCTAssertEqual(elements, [
            .init(name: "meta", metadata: ["property": "\"og:title\"", "content": "\"The Rock\""]),
            .init(name: "meta", metadata: ["property": "\"og:type\"", "content": "\"video.movie\""]),
            .init(name: "meta", metadata: ["property": "\"og:url\"", "content": "\"https://www.imdb.com/title/tt0117500/\""]),
            .init(name: "meta", metadata: ["property": "\"og:image\"", "content": "\"https://ia.media-imdb.com/images/rock.jpg\""])
        ])
    }
}

let htmlText = """
<html prefix="og: https://ogp.me/ns#">
<head>
<title>The Rock (1996)</title>
<meta property="og:title" content="The Rock" />
<meta property="og:type" content="video.movie" />
<meta property="og:url" content="https://www.imdb.com/title/tt0117500/" />
<meta property="og:image" content="https://ia.media-imdb.com/images/rock.jpg" />
</head>
<html>
</html>
"""
