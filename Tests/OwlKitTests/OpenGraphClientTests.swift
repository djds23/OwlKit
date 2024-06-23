//
//  OpenGraphClientTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OwlKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class OpenGraphClientTests: XCTestCase {

    func testDocumentParsingExtractsProperlyTypedMedia() async throws {
        let networking = Networking { url in
            let output = try XCTUnwrap(htmlText.data(using: .utf8))
            let response = URLResponse(url: url, mimeType: "text/html", expectedContentLength: 300, textEncodingName: nil)
            return (output, response)
        }

        let testURL = try XCTUnwrap(URL(string: "https://www.imdb.com/title/tt0117500/"))
        let client = OpenGraphClient(networking: networking)
        let elements = try await client.parse(url: testURL)

        let urlData: OGMetadata = try XCTUnwrap(.urlType(name: "og:url", rawValue: "https://www.imdb.com/title/tt0117500/"))
        let imageData: OGMetadata = try XCTUnwrap(.urlType(name: "og:image", rawValue: "https://ia.media-imdb.com/images/rock.jpg"))
        XCTAssertEqual(elements, [
            "og:title" : [.stringType(name: "og:title", rawValue: "The Rock")],
            "og:type" : [.stringType(name: "og:type", rawValue: "video.movie")],
            "og:url" : [urlData],
            "og:image" : [imageData]
        ])
    }

    func testDocumentWithArrays() async throws {
        let networking = Networking { url in
            let output = try XCTUnwrap(htmlWithArraysText.data(using: .utf8))
            let response = URLResponse(url: url, mimeType: "text/html", expectedContentLength: 300, textEncodingName: nil)
            return (output, response)
        }

        let testURL = try XCTUnwrap(URL(string: "https://www.imdb.com/title/tt0117500/"))
        let client = OpenGraphClient(networking: networking)
        let elements = try await client.parse(url: testURL)
        let imageData: OGMetadata = try XCTUnwrap(.urlType(name: "og:image", rawValue: "https://ia.media-imdb.com/images/rock.jpg"))
        let imageData1: OGMetadata = try XCTUnwrap(.urlType(name: "og:image", rawValue: "https://ia.media-imdb.com/images/rock-1.jpg"))
        let imageData2: OGMetadata = try XCTUnwrap(.urlType(name: "og:image", rawValue: "https://ia.media-imdb.com/images/rock-2.jpg"))
        let imageData3: OGMetadata = try XCTUnwrap(.urlType(name: "og:image", rawValue: "https://ia.media-imdb.com/images/rock-3.jpg"))
        XCTAssertEqual(elements, [
            "og:image" : [imageData, imageData1, imageData2, imageData3]
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

let htmlWithArraysText = """
<html prefix="og: https://ogp.me/ns#">
<head>
<title>The Rock (1996)</title>
<meta property="og:image" content="https://ia.media-imdb.com/images/rock.jpg" />
<meta property="og:image" content="https://ia.media-imdb.com/images/rock-1.jpg" />
<meta property="og:image" content="https://ia.media-imdb.com/images/rock-2.jpg" />
<meta property="og:image" content="https://ia.media-imdb.com/images/rock-3.jpg" />
</head>
<html>
</html>
"""
