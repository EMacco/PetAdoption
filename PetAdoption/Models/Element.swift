//
//  Element.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 28/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct Element: Decodable {
    let type: ElementType
    let rules: [Rule]
    let uniqueId: String
    let file: String?
    let label: String?
    let isMandatory: Bool?
    let keyboard: KeyboardType?
    let formattedNumeric: String?
    let mode: Mode?
    
    enum CodingKeys: String, CodingKey {
        case type, file, uniqueId="unique_id", rules, label, isMandatory, keyboard, formattedNumeric, mode
    }
}

//  MARK:- Element Type Enum
enum ElementType: String, Decodable {
    case embeddedPhoto = "embeddedphoto"
    case text
    case yesNo = "yesno"
    case formattedNumeric = "formattednumeric"
    case dateTime = "datetime"
    case sectionTitle
    case pageTitle
    case other
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = ElementType(rawValue: label) ?? .other
    }
}

//  MARK:- Keyboard Type Enum
enum KeyboardType: String, Decodable {
    case numeric
    case email
    case normal
    case password
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = KeyboardType(rawValue: label) ?? .normal
    }
}

//  MARK:- Picker Mode Enum
enum Mode: String, Decodable {
    case date
    case select
    case other
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = Mode(rawValue: label) ?? .other
    }
}
