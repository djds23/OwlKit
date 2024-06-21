//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/19/24.
//

import Foundation
import RegexBuilder

class Parser {

    func parse(document: Data?) -> [String] {
        guard 
            let data = document,
            let documentString = String(data: data, encoding: .utf8)
        else { return [] }
        return parse(document: documentString)
    }
    func parse(document: String) -> [String] {
        let captureHead = Regex {
            One("<head>")
            Capture {
                OneOrMore(.any)
            }
            One("</head>")
        }
//        let metaBody = Regex {
//
//        }
//        let optionalPropertyPairing = Regex {
//            Optionally {
//                ZeroOrMore(.whitespace)
//                One("=")
//                ZeroOrMore(.whitespace)
//                One("\"")
//
////                One("\"")
//            }
//        }
//        let metaTags = Regex {
//            One("<")
//            ZeroOrMore(.whitespace)
//            One("meta")
//            Capture {
//                OneOrMore {
//                    ZeroOrMore(.whitespace)
//                    OneOrMore(.word)
//                    optionalPropertyPairing
//                }
//            }
//            One(">")
//        }

        guard let head = document.firstMatch(of: captureHead)?.output.0 else { return [] }


        // Find all of the opening meta tags
        // find all of the closing tags
        // build all of the full sets
        // parse the insides
        let scanner = Scanner(head: String(head))
        scanner.scan()
        return scanner.output
    }
}

class Scanner {
    var current = 0
    var start: String.Index
    var head: String
    var token: String?

    var output = [String]()
    init(head: String) {
        start = head.startIndex
        self.head = head
    }


    func scan() {
        while isAtEnd() == false {
            let newStart = head.index(head.startIndex, offsetBy: current)
            print(current)
            start = newStart
            scanToken()
        }
    }

    func scanToken() {
        let c = advance()
        switch c {
        case "<":
            // If we find a LT sign, we are at an opening tag
            parseTag()
        default:
            print("found char \(c)")
            break
        }
    }

    func parseTag() {
//        parseName()
        var searchForClosingTag = true
        while isAtEnd() == false && searchForClosingTag{
            let c = advance()
            switch c {
            case ">":
                searchForClosingTag = false
            default:
                break
            }
        }
        addToken()
    }

    func addToken() {
        let tag = head[start..<head.index(head.startIndex, offsetBy: current)]
        print(tag)
        output.append(String(tag))
    }

    func parseName() {
        while isAtEnd() == false {
            let c = advance()
            if (c.isWhitespace || c.isLetter) == false {
                break
            }
        }
    }

    func isAtEnd() -> Bool {
        current >= head.count
    }

    func advance() -> Character {
        current += 1
        return currentChar()
    }

    func currentChar() -> Character {
        let index = head.index(head.startIndex, offsetBy: current - 1)
        return head[index]
    }
}
