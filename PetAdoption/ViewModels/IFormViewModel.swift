//
//  IFormViewModel.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 27/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol IFormViewModel {
    func submitForm()
    func getPagesTableViewIdentifiers()
    func isCollapsed(id: String) -> Bool
    func getElementsToHide(element: Element)
    func getUserInput(id: String) -> String?
    func updateUserInput(id: String, value: String?)
    var formSubmitionResponse: PublishSubject<String> { get }
    var pagesTableViewIdentifiers: PublishSubject<[PageConfig]> { get }
}
