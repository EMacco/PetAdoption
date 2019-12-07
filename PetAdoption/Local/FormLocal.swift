//
//  FormLocal.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 09/12/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import Foundation

class FormLocal: IFormLocal {
    func getJsonData(from fileName: String) -> Form? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
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
}
