//
//  IFormViewModel.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 27/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation
import RxSwift

protocol IFormViewModel {
    func getPagesTableViewIdentifiers()
    var pagesTableViewIdentifiers: PublishSubject<[PageConfig]> { get }
}
