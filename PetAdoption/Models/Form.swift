//
//  Form.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 27/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct Form: Decodable {
    let id: String
    let name: String
    let pages: [Page]
}
