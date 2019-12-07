//
//  ViewModelTests.swift
//  PetAdoptionTests
//
//  Created by Emmanuel Okwara on 09/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import XCTest
@testable import PetAdoption

class ViewModelTests: XCTestCase {
    
    var formViewModel: IFormViewModel?
    
    override func setUp() {
        
        formViewModel = FormViewModel(formLocal: FormLocal())
    }

    override func tearDown() {
        formViewModel = nil
    }

    func test_getValidJsonData() {
//        formViewModel?.getPagesTableViewIdentifiers()
    }

}
