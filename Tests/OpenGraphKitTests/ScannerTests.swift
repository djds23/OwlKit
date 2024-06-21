//
//  ScannerTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OpenGraphKit

final class ScannerTests: XCTestCase {
    func testScannerFindsAllTags() throws {
        let expectedTags = [
            "<head>",
            "<meta charset=\"utf-8\">",
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
            "<title>",
            "</title>",
            "<link rel=\"stylesheet\" href=\"css/style.css\">",
            "<meta name=\"description\" content=\"\">",
            "<meta property =\"og:title\" content=\"Foo\">",
            "<meta property=\"og:type\" content=\"website\">",
            "<meta property=\"og:url\" content=\"fart.biz/whatup\">",
            "<meta property=\"og:image\" content=\"lol.png\">",
            "<meta property=\"og:image:alt\" content=\"dang\">",
            "<link rel=\"icon\" href=\"/favicon.ico\" sizes=\"any\">",
            "<link rel=\"icon\" href=\"/icon.svg\" type=\"image/svg+xml\">",
            "<link rel=\"apple-touch-icon\" href=\"icon.png\">",
            "<link rel=\"manifest\" href=\"site.webmanifest\">",
            "<meta name=\"theme-color\" content=\"#fafafa\">",
            "</head>"
        ]
        let scanner = Scanner(head: head)
        scanner.scan()
        XCTAssertEqual(scanner.output.count, expectedTags.count)
        for line in scanner.output {
            let isContained = expectedTags.contains { str in
                str == line
            }
            if isContained == false { // Easier to find differences when we got a failure
                XCTFail("There is no string \(line) in expectedTags")
            }
        }
        XCTAssertEqual(scanner.output, expectedTags)
    }
}

let head = """
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title></title>
  <link rel="stylesheet" href="css/style.css">
  <meta name="description" content="">

  <meta property ="og:title" content="Foo">
  <meta property="og:type" content="website">
  <meta property="og:url" content="fart.biz/whatup">
  <meta property="og:image" content="lol.png">
  <meta property="og:image:alt" content="dang">

  <link rel="icon" href="/favicon.ico" sizes="any">
  <link rel="icon" href="/icon.svg" type="image/svg+xml">
  <link rel="apple-touch-icon" href="icon.png">

  <link rel="manifest" href="site.webmanifest">
  <meta name="theme-color" content="#fafafa">
</head>
"""
