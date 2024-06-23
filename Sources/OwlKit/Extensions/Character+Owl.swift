//
//  Character+Owl.swift
//  
//
//  Created by Dean Silfen on 6/22/24.
//

import Foundation

extension Character {
    var isValidBodyCharacter: Bool {
        isLetter || isNumber || self == "-"
    }
}
