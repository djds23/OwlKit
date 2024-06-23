//
//  String+Owl.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import Foundation

extension String {
    var withoutInnerStringQuotes: String {
        guard self.hasPrefix("\"") && self.hasSuffix("\"") else { return self }
        return String(self[self.index(after: self.startIndex)..<self.index(before: self.endIndex)])
    }
}
