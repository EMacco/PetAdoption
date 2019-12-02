//
//  OptionTableViewCell.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 28/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {
    private var elementID: String?
    var formViewModel: IFormViewModel?
    var allPagesTableViews: [UITableView]?
    var elementInfo: Element? {
        didSet {
            elementID = elementInfo!.uniqueId
            titleLbl.text = elementInfo!.label
            setSwitchStatus()
        }
    }
    
    // MARK:- Create View Elements
    private let switchView: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.anchor(width: 60)
        view.onTintColor = UIColor.appColors.red
        return view
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }()
    
    private let yesLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        label.font = label.font.withSize(9)
        label.anchor(width: 17)
        label.text = "Yes"
        return label
    }()
    
    private let noLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        label.font = label.font.withSize(9)
        label.anchor(width: 17)
        label.text = "No"
        return label
    }()
    
    private let requiredLbl: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor.appColors.red
        return label
    }()
    
    // MARK:- Configure Views and constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(switchView)
        addSubview(titleLbl)
        addSubview(yesLbl)
        addSubview(noLbl)
        
        switchView.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
        
        titleLbl.anchor(top: topAnchor, paddingTop: 20, bottom: bottomAnchor, paddingBottom: 20, right: noLbl.leftAnchor, paddingRight: 10)
        switchView.anchor(paddingBottom: 12, right: yesLbl.leftAnchor)
        switchView.centerVertically(with: self)
        yesLbl.anchor(left: switchView.rightAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 20)
        yesLbl.centerVertically(with: self)
        noLbl.anchor(right: switchView.leftAnchor, paddingRight: 4)
        noLbl.centerVertically(with: self)
    }
    
    private func setSwitchStatus() {
        let currentVal = (formViewModel?.getUserInput(id: elementID!) ?? "No")
        switchView.isOn = currentVal == "Yes" ? true : false
        
        let mandatory = elementInfo?.isMandatory ?? false
        if mandatory {
            addSubview(requiredLbl)
            requiredLbl.anchor(top: topAnchor, paddingTop: 25, left: leftAnchor, paddingLeft: 20, width: 10, height: 10)
            titleLbl.anchor(left: leftAnchor, paddingLeft: 30)
        } else {
            requiredLbl.removeFromSuperview()
            titleLbl.anchor(left: leftAnchor, paddingLeft: 20)
        }
    }
    
    @objc private func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            formViewModel?.updateUserInput(id: elementID!, value: "Yes")
        } else {
            formViewModel?.updateUserInput(id: elementID!, value: "No")
        }
        formViewModel?.getElementsToHide(element: elementInfo!)
        
        guard let tables = self.allPagesTableViews else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for table in tables {
                table.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
