//
//  NonEmptyContainer.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import Foundation

public struct NonEmptyContainer<Element> {
    public var head: Element
    public var tail: [Element]

    public var elements: [Element] {
        [head] + tail
    }

    init(head: Element, tail: [Element]) {
        self.head = head
        self.tail = tail
    }

    static func + (_ lhs: NonEmptyContainer<Element>, _ rhs: NonEmptyContainer<Element>) -> NonEmptyContainer<Element> {
        .init(head: lhs.head, tail: lhs.tail + rhs.elements)
    }
}

extension NonEmptyContainer: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        head = elements[elements.startIndex]
        if elements.count > 1 {
            tail = Array(elements[elements.startIndex + 1..<elements.endIndex])
        } else {
            tail = []
        }
    }
}

extension NonEmptyContainer: Equatable where Element: Equatable { }
