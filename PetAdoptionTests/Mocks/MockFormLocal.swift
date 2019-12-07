//
//  MockFormLocal.swift
//  PetAdoptionTests
//
//  Created by Emmanuel Okwara on 09/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation
@testable import PetAdoption

class MockFormLocal: IFormLocal {
    func getJsonData(from fileName: String) -> Form? {
        return nil
    }
}
