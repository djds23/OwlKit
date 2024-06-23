//
//  Scanner.swift
//  
//
//  Created by Dean Silfen on 6/21/24.
//

import Foundation

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
    var document: String
    var token: String?

    var output = [Token]()
    init(document: String) {
        start = document.startIndex
        self.document = document
    }


    func scan() {
        while isAtEnd() == false {
            let newStart = document.index(document.startIndex, offsetBy: current)
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
        let value = document[start..<document.index(document.startIndex, offsetBy: current)]
        output.append(.init(type: token, value: String(value)))
    }

    func isAtEnd() -> Bool {
        current >= document.count
    }

    @discardableResult
    func advance() -> Character {
        current += 1
        return currentChar()
    }

    func currentChar() -> Character {
        let index = document.index(document.startIndex, offsetBy: current - 1)
        return document[index]
    }

    func peek() -> Character {
        let index = document.index(document.startIndex, offsetBy: current)
        return document[index]
    }

    func parseString() {
        while isAtEnd() == false && peek() != "\""  {
            advance()
        }
        advance() // closing "

        addToken(.string)
    }
}
