//
//  PageConfig.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 29/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation
import RxDataSources

struct PageConfig {
    let name: String
    let identifiers: [ElementType]
    let dataSource: [SectionModel<String, Element>]
}
