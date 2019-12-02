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
    let rules: [Rule]?
    let uniqueId: String
    let file: String?
    let label: String?
    let isMandatory: Bool?
    let keyboard: KeyboardType?
    let formattedNumeric: String?
    let mode: Mode?
    let options: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type, file, uniqueId="unique_id", rules, label, isMandatory, keyboard, formattedNumeric, mode, options
    }
}

//  MARK:- Element Type Enum
enum ElementType: String, Decodable {
    case embeddedPhoto = "embeddedphoto"
    case text
    case yesNo = "yesno"
    case formattedNumeric = "formattednumeric"
    case dateTime = "datetime"
}

//  MARK:- Keyboard Type Enum
enum KeyboardType: String, Decodable {
    case numeric
    case email
    case normal
    case password
}

//  MARK:- Picker Mode Enum
enum Mode: String, Decodable {
    case date
    case select
}
