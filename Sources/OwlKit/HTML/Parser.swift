//
//  Parser.swift
//  
//
//  Created by Dean Silfen on 6/19/24.
//

import Foundation
import RegexBuilder

// Experimental HTML Parser
// https://www.w3.org/TR/2011/WD-html-markup-20110113/syntax.html#:~:text=A%20void%20element%20is%20an,param%20%2C%20source%20%2C%20track%20%2C%20wbr
class Parser {
    let scanner: Scanner
    var current = 0
    var elements = [HTMLElement]()
    init(document: String) {
        scanner = Scanner(document: document)
    }

    func parse() {
        guard elements.isEmpty else { return }
        scanner.scan()
        
        var currentElement: HTMLElement?
        while isAtEnd() == false {
            let t = advance()
            switch t.type {
            case .openingBracket:
                currentElement = HTMLElement(name: peek().value)
            case .guts:
                let next = peek()
                if next.type == .equals {
                    let nextAfter = peek(by: 1)
                    if nextAfter.type == .string {
                        currentElement?.attributes[t.value] = nextAfter.value
                    }
                }
            case .closingBracket:
                if let element = currentElement, element.isVoidElement {
                    elements.append(element)
                    currentElement = nil
                }
            case .contents:
                currentElement?.contents = t.value
            case .startClosingBracket:
                if let element = currentElement {
                    elements.append(element)
                    currentElement = nil
                }
            case .equals, .string:
                break
            }
        }
    }

    func isAtEnd() -> Bool {
        current >= scanner.output.count
    }

    func advance() -> Token {
        current += 1
        return currentChar()
    }

    func currentChar() -> Token {
        let index = scanner.output.index(scanner.output.startIndex, offsetBy: current - 1)
        return scanner.output[index]
    }

    func peek(by: Int = 0) -> Token {
        let index = scanner.output.index(scanner.output.startIndex, offsetBy: current + by)
        return scanner.output[index]
    }
}
