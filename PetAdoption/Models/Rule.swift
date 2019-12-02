//
//  Rule.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 28/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

enum Condition: String, Decodable {
    case equals, other
    
    init(decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = Condition(rawValue: label) ?? .other
    }
}

enum RuleValue: String, Decodable {
    case Yes, No, other
    
    init(decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = RuleValue(rawValue: label) ?? .other
    }
}

struct Rule: Decodable {
    let condition: Condition
    let value: RuleValue
    let action: String
    let otherwise: String
    let targets: [String]
}
