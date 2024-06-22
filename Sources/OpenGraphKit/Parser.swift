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
        // We just want the head because that is where all the meta elements are. Should be able to easily swipe that with Regex
        let captureHead = Regex {
            One("<head>")
            Capture {
                OneOrMore(.any)
            }
            One("</head>")
        }

        guard let head = document.firstMatch(of: captureHead)?.output.0 else { return [] }


        // Take get all of the tags from the head
        let scanner = Scanner(head: String(head))
        scanner.scan()
        // Find all of the meta tags, meta tags are "void" so they are single elements and not pairs
        // Find all the meta elements with a property & content, then build the elements
        // See full spec https://html.spec.whatwg.org/multipage/semantics.html#the-meta-element
        // build all of the full sets
        // parse the insides
        // https://stackoverflow.com/questions/6402528/opengraph-or-schema-org
        return scanner.output.map { $0.value }
    }
}

enum TokenType: Equatable {
    case string
    case openingBracket
    case closingBracket
    case startClosingBracket
    case equals
    case guts
}

struct Token: Equatable {
    var type: TokenType
    var value: String
}

class Scanner {
    var current = 0
    var start: String.Index
    var head: String
    var token: String?

    var output = [Token]()
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
            let nextUp = peek()
            if nextUp == "/" {
                advance()
                addToken(.startClosingBracket)
            } else {
                // If we find a LT sign, we are at an opening tag
                addToken(.openingBracket)
            }
        case ">":
            addToken(.closingBracket)
        case "\"":
            parseString()
        case "=":
            addToken(.equals)
        default:
            if c.isValidBodyCharacter {
                parseBody()
            } else {
                print("unclear how to parse \(c)")
            }
        }
    }

    func parseBody() {
        var searchForClosingTag = true
        while isAtEnd() == false && searchForClosingTag{
            let c = peek()
            if c.isValidBodyCharacter {
                _ = advance()
            } else {
                searchForClosingTag = false
            }
        }
        addToken(.guts)
    }

    func addToken(_ token: TokenType) {
        let value = head[start..<head.index(head.startIndex, offsetBy: current)]
        output.append(.init(type: token, value: String(value)))
    }

    func isAtEnd() -> Bool {
        current >= head.count
    }

    @discardableResult
    func advance() -> Character {
        current += 1
        return currentChar()
    }

    func currentChar() -> Character {
        let index = head.index(head.startIndex, offsetBy: current - 1)
        return head[index]
    }

    func peek() -> Character {
        let index = head.index(head.startIndex, offsetBy: current)
        return head[index]
    }

    func parseString() {
        while isAtEnd() == false && peek() != "\""  {
            advance()
        }
        advance() // closing "

        addToken(.string)
    }
}

extension Character {
    var isValidBodyCharacter: Bool {
        isLetter || isNumber || self == "-"
    }
}
