//
//  String+Extension.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 01/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

extension String {
    func formatPhoneNumber(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
