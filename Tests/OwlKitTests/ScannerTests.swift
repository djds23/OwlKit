//
//  ScannerTests.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import XCTest
@testable import OwlKit

final class ScannerTests: XCTestCase {
    func testStringScanner() {
        let scanner = Scanner(document: "\"hello, world!\"")
        scanner.scan()
        XCTAssertEqual(scanner.output.count, 1)
        XCTAssertEqual(scanner.output, [.init(type: .string, value: "\"hello, world!\"")])
    }

    func testBracketsScanner() {
        let scanner = Scanner(document: "<head>Hello, world!</head>")
        scanner.scan()
        XCTAssertEqual(scanner.output.count, 7)
        XCTAssertEqual(scanner.output, [
            .init(type: .openingBracket, value: "<"),
            .init(type: .guts, value: "head"),
            .init(type: .closingBracket, value: ">"),
            .init(type: .contents, value: "Hello, world!"),
            .init(type: .startClosingBracket, value: "</"),
            .init(type: .guts, value: "head"),
            .init(type: .closingBracket, value: ">"),
        ])
    }

    func testMetaTag() {
        let scanner = Scanner(document: "<meta name=\"viewport\">")
        scanner.scan()
        XCTAssertEqual(scanner.output.count, 6)
        XCTAssertEqual(scanner.output, [
            .init(type: .openingBracket, value: "<"),
            .init(type: .guts, value: "meta"),
            .init(type: .guts, value: "name"),
            .init(type: .equals, value: "="),
            .init(type: .string, value: "\"viewport\""),
            .init(type: .closingBracket, value: ">"),
        ])
    }

    func testLinkTag() {
        let scanner = Scanner(document: "<link rel=\"icon\" href=\"/icon.svg\" type=\"image/svg+xml\">")
        scanner.scan()
        XCTAssertEqual(scanner.output.count, 12)
        XCTAssertEqual(scanner.output, [
            .init(type: .openingBracket, value: "<"),
            .init(type: .guts, value: "link"),
            .init(type: .guts, value: "rel"),
            .init(type: .equals, value: "="),
            .init(type: .string, value: "\"icon\""),
            .init(type: .guts, value: "href"),
            .init(type: .equals, value: "="),
            .init(type: .string, value: "\"/icon.svg\""),
            .init(type: .guts, value: "type"),
            .init(type: .equals, value: "="),
            .init(type: .string, value: "\"image/svg+xml\""),
            .init(type: .closingBracket, value: ">"),
        ])
    }

    func testMetaWithHTMLEquivolent() {
        let scanner = Scanner(document: "<meta http-equiv=\"content-type\">")
        scanner.scan()
        XCTAssertEqual(scanner.output.count, 6)
        XCTAssertEqual(scanner.output, [
            .init(type: .openingBracket, value: "<"),
            .init(type: .guts, value: "meta"),
            .init(type: .guts, value: "http-equiv"),
            .init(type: .equals, value: "="),
            .init(type: .string, value: "\"content-type\""),
            .init(type: .closingBracket, value: ">"),
        ])
    }

    func testElementWithNoContents() {
        let scanner = Scanner(document: "<script src=\"js/app.js\"></script>")
        scanner.scan()
        XCTAssertEqual(scanner.output.count, 9)
        XCTAssertEqual(scanner.output, [
            .init(type: .openingBracket, value: "<"),
            .init(type: .guts, value: "script"),
            .init(type: .guts, value: "src"),
            .init(type: .equals, value: "="),
            .init(type: .string, value: "\"js/app.js\""),
            .init(type: .closingBracket, value: ">"),
            .init(type: .startClosingBracket, value: "</"),
            .init(type: .guts, value: "script"),
            .init(type: .closingBracket, value: ">"),
        ])
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
