//
//  File.swift
//  
//
//  Created by Dean Silfen on 6/19/24.
//

import Foundation
import RegexBuilder

struct HTMLElement: Equatable {
    var name: String
    var metadata = [String: String]()

    internal init(name: String, metadata: [String : String] = [String: String]()) {
        self.name = name
        self.metadata = metadata
    }
}

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
                    currentElement?.metadata[t.value] = peek(by: 1).value
                }
            case .closingBracket:
                if let element = currentElement {
                    elements.append(element)
                    currentElement = nil
                }
            case .startClosingBracket, .equals, .string:
                print("Unusable media \(t)")
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
