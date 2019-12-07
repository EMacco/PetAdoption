//
//  IFormLocal.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 09/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

protocol IFormLocal {
    func getJsonData(from fileName: String) -> Form? 
}
