//
//  Summary.swift
//  
//
//  Created by Dean Silfen on 7/13/24.
//
import Foundation

public struct Summary {
    public var title: String
    public var url: URL
    public var description: String?
    public var author: String?
    public var image: URL?

    public init(title: String, url: URL, description: String? = nil, author: String? = nil, image: URL? = nil) {
        self.title = title
        self.url = url
        self.description = description
        self.author = author
        self.image = image
    }

    static func forURL(
        _ url: URL,
        ogData: [OGIdentifier: NonEmptyContainer<OGMetadata>],
        standard: [StandardIdentifier: NonEmptyContainer<StandardMetadata>]
    ) -> Self? {
        guard let title = standard[.title]?.head.value ?? ogData[.title]?.head.value.string else { return nil }
        return .init(
            title: title,
            url: url,
            description: standard[.description]?.head.value ?? ogData[.description]?.head.value.string,
            author: standard[.author]?.head.value,
            image: ogData[.image]?.head.value.url
        )
    }
}
