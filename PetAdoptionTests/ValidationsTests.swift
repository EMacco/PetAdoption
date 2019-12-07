//
//  ValidationsTests.swift
//  PetAdoptionTests
//
//  Created by Emmanuel Okwara on 09/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import XCTest
@testable import PetAdoption

class ValidationsTests: XCTestCase {
    
    func test_mandatoryFieldProvided() {
        let input = ["txt2": "Okwara"]
        let mandatoryFields: Set<String> = ["txt1", "txt2"]
        
        let error = FormValidation.validateForm(input: input, mandatory: mandatoryFields, emails: nil, formattedString: nil)
        
        XCTAssertEqual(error, "Please fill all required fields")
    }
    
    func test_mandatoryFieldNoProvided() {
        let input = ["txt1": "Emmanuel"]
        let mandatoryFields: Set<String> = ["txt1"]
        let error = FormValidation.validateForm(input: input, mandatory: mandatoryFields, emails: nil, formattedString: nil)
        
        XCTAssertNil(error)
    }
    
    func test_validEmail() {
        let input = ["txt1": "emma@emma.com"]
        let emailFields: Set<String> = ["txt1"]
        
        let error = FormValidation.validateForm(input: input, mandatory: [], emails: emailFields, formattedString: nil)
        
        XCTAssertNil(error)
    }
    
    func test_invalidEmail() {
        let input = ["txt1": "emma"]
        let emailFields: Set<String> = ["txt1"]
        
        let error = FormValidation.validateForm(input: input, mandatory: [], emails: emailFields, formattedString: nil)
        
        XCTAssertEqual(error, "emma is not a valid email")
    }
    
    func test_matchFormatterPattern() {
        let input = ["txt1": "1323"]
        let formattedString = ["txt1": "###-####-###"]
        
        let error = FormValidation.validateForm(input: input, mandatory: [], emails: nil, formattedString: formattedString)
        
        XCTAssertEqual(error, "1323 does not match pattern ###-####-###")
    }
    
    func test_notMatchFormatterPattern() {
        let input = ["txt1": "132-3324-434"]
        let formattedString = ["txt1": "###-####-###"]
        
        let error = FormValidation.validateForm(input: input, mandatory: [], emails: nil, formattedString: formattedString)
        
        XCTAssertNil(error)
    }
}
