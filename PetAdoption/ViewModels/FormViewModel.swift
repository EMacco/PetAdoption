//
//  FormViewModel.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 27/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class FormViewModel: IFormViewModel {
    
    var form: Form?
    private var emailElements = Set<String>()
    private var userInput = [String: String]()
    private var collapsedElements = Set<String>()
    private var mandatoryElements = Set<String>()
    private var formattedStringElements = [String: String]()
    var formSubmitionResponse: PublishSubject<String> = PublishSubject()
    var pagesTableViewIdentifiers: PublishSubject<[PageConfig]> = PublishSubject()
    
    init() {
        self.form = getJsonData()
    }
    
    // MARK:- Generate tableviews
    func getPagesTableViewIdentifiers() {
        if let pages = self.form?.pages {
            var pagesConfig = [PageConfig]()
            for page in pages {
                pagesConfig.append(PageConfig(name: page.label, identifiers: getTableViewCellIdentifiers(for: page), dataSource: getDataSource(for: page)))
            }
            self.pagesTableViewIdentifiers.onNext(pagesConfig)
        }
    }
    
    // MARK:- Generate Datasource
    private func getDataSource(for page: Page) -> [SectionModel<String, Element>] {
        var pageInfo = [SectionModel<String, Element>]()
        
        for section in page.sections {
            var sectionElements = [Element]()
            for element in section.elements {
                sectionElements.append(element)
                extractValidationFields(element)
            }
            pageInfo.append(SectionModel(model: section.label, items: sectionElements))
        }

        return pageInfo
        
    }
    
    // MARK:- Validation Fields
    private func extractValidationFields(_ element: Element) {
        if element.isMandatory ?? false {
            mandatoryElements.insert(element.uniqueId)
        }
        
        if let keyboard = element.keyboard, keyboard == .email {
            emailElements.insert(element.uniqueId)
        }
        
        if let keyboard = element.keyboard, keyboard == .numeric {
            formattedStringElements[element.uniqueId] = element.formattedNumeric
        }
    }
    
    // MARK:- Retrieve and Decode JSON Data
    private func getJsonData() -> Form? {
        if let url = Bundle.main.url(forResource: "pet_adoption", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Form.self, from: data)
                return jsonData
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK:- Get tableview identifiers
    private func getTableViewCellIdentifiers(for page: Page) -> [ElementType] {
        var identifiers = Set<ElementType>()
        
        for section in page.sections {
            for element in section.elements {
                getElementsToHide(element: element)
                identifiers.insert(element.type)
            }
        }
        
        return Array(identifiers)
    }
    
    // MARK:- Show/Hide Elements
    func getElementsToHide(element: Element) {
        for rule in element.rules {
            let actual = RuleValue(rawValue: userInput[element.uniqueId] ?? "No") ?? RuleValue.No
            let expected = rule.value
            if compareRule(actual: actual, expected: expected, operation: rule.condition) {
                if rule.action == "show" {
                    showElement(elements: rule.targets)
                } else {
                    hideElement(elements: rule.targets)
                }
            } else {
                if rule.otherwise == "show" {
                    showElement(elements: rule.targets)
                } else {
                    hideElement(elements: rule.targets)
                }
            }
        }
    }
    
    func isCollapsed(id: String) -> Bool {
        return collapsedElements.contains(id)
    }
    
    private func compareRule(actual: RuleValue, expected: RuleValue, operation: Condition) -> Bool {
        switch operation {
            case .equals:
                return actual == expected
            default:
                return false
        }
    }
    
    private func hideElement(elements: [String]) {
        for id in elements {
            self.collapsedElements.insert(id)
        }
    }
    
    private func showElement(elements: [String]) {
        for id in elements {
            guard let index = self.collapsedElements.firstIndex(of: id) else { continue }
            self.collapsedElements.remove(at: index)
        }
    }
    
    // MARK:- Update and Retrieve User Input
    func getUserInput(id: String) -> String? {
        return userInput[id]
    }
    
    func updateUserInput(id: String, value: String?) {
        userInput[id] = value
    }
    
    // MARK:- Form Submission
    func submitForm() {
        let error =  FormValidation.validateForm(input: userInput,
                                                 mandatory: mandatoryElements,
                                                 emails: emailElements,
                                                 formattedString: formattedStringElements)
        
        formSubmitionResponse.onNext(error ?? "")
    }
}
