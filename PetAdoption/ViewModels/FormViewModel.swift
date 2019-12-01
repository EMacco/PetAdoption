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
    
    var pagesTableViewIdentifiers: PublishSubject<[PageConfig]> = PublishSubject()
    var form: Form?
    
    func getPagesTableViewIdentifiers() {
        self.form = getJsonData()
        if let pages = self.form?.pages {
            var pagesConfig = [PageConfig]()
            for page in pages {
                pagesConfig.append(PageConfig(name: page.label, identifiers: getTableViewCellIdentifiers(for: page), dataSource: getDataSource(for: page)))
            }
            self.pagesTableViewIdentifiers.onNext(pagesConfig)
        }
    }
    
    private func getDataSource(for page: Page) -> [SectionModel<String, Element>] {
        var pageInfo = [SectionModel<String, Element>]()
        
        for section in page.sections {
            var sectionElements = [Element]()
            for element in section.elements {
                sectionElements.append(element)
            }
            pageInfo.append(SectionModel(model: section.label, items: sectionElements))
        }

        return pageInfo
        
    }
    
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
    
    private func getTableViewCellIdentifiers(for page: Page) -> [ElementType] {
        var identifiers = Set<ElementType>()
        
        for section in page.sections {
            for element in section.elements {
                identifiers.insert(element.type)
            }
        }
        
        return Array(identifiers)
    }
    
}
