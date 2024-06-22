//
//  OpenGraphClientTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OwlKit

final class OpenGraphClientTests: XCTestCase {

    func testDocumentParsingExtractsProperlyTypedMedia() async throws {
        let networking = OpenGraphClient.Networking { _ in
            let output = try XCTUnwrap(htmlText.data(using: .utf8))
            let response = URLResponse()
            return (output, response)
        }

        let testURL = try XCTUnwrap(URL(string: "https://www.imdb.com/title/tt0117500/"))
        let client = OpenGraphClient(networking: networking)
        let elements = try await client.parse(url: testURL)

        let urlData: OGMetadata = try XCTUnwrap(.urlType(name: "og:url", rawValue: "https://www.imdb.com/title/tt0117500/"))
        let imageData: OGMetadata = try XCTUnwrap(.urlType(name: "og:image", rawValue: "https://ia.media-imdb.com/images/rock.jpg"))
        XCTAssertEqual(elements, [
            .stringType(name: "og:title", rawValue: "The Rock"),
            .stringType(name: "og:type", rawValue: "video.movie"),
            urlData,
            imageData
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
