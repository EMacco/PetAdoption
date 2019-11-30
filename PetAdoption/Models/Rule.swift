//
//  Rule.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 28/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

enum Conditions: String, Decodable {
    case equals, greater, less, other
    
    init(decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = Conditions(rawValue: label) ?? .other
    }
}

struct Rule: Decodable {
    let condition: Conditions
    let value: String
    let action: String
    let otherwise: String
    let targets: [String]
}
