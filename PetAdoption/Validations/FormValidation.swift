//
//  FormValidation.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 02/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

class FormValidation {
    private static func validEmail(emails: Set<String>, input: [String: String]) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        for id in emails {
            guard let email = input[id]?.trimmingCharacters(in: .whitespacesAndNewlines), email != "" else { continue }
            if !emailTest.evaluate(with: email) {
                return "\(email) is not a valid email"
            }
        }
        
        return nil
    }
    
    private static func matchesPattern(formatted: [String: String], input: [String: String]) -> String? {
        for (id, pattern) in formatted {
            guard let value = input[id]?.trimmingCharacters(in: .whitespacesAndNewlines), value != "" else { continue }
            let error = "\(value) does not match pattern \(pattern)"
            if value.count != pattern.count { return error }
            
            var encoded = ""
            for char in value {
                if char.isNumber {
                    encoded += "#"
                } else {
                    encoded += String(char)
                }
            }
            
            if encoded != pattern {
                return error
            }
        }
        return nil
    }
    
    private static func filledRequiredFields(required: Set<String>, input: [String: String]) -> String? {
        for id in required {
            let input = input[id]
            if input == nil || input?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill all required fields"
            }
        }
        return nil
    }
    
    static func validateForm(input: [String: String], mandatory: Set<String>, emails: Set<String>?, formattedString: [String: String]?) -> String? {
        
        if let error = filledRequiredFields(required: mandatory, input: input) { return error }
        
        if let emails = emails {
            if let error = validEmail(emails: emails, input: input) { return error }
        }
        
        if let formattedString = formattedString {
            if let error = matchesPattern(formatted: formattedString, input: input) { return error }
        }
        
        return nil
    }
}
