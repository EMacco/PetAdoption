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
    var elementInfo: Element? {
        didSet {
            elementID = elementInfo!.uniqueId
            titleLbl.text = elementInfo!.label
        }
    }
    
    // MARK:- Create View Elements
    private let switchView: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
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
    
    // MARK:- Configure Views and constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(switchView)
        addSubview(titleLbl)
        addSubview(yesLbl)
        addSubview(noLbl)
        
        titleLbl.anchor(top: topAnchor, paddingTop: 20, bottom: bottomAnchor, paddingBottom: 20, left: leftAnchor, paddingLeft: 20, right: noLbl.leftAnchor, paddingRight: 10)
        switchView.anchor(paddingBottom: 12, right: yesLbl.leftAnchor)
        switchView.centerVertically(with: self)
        yesLbl.anchor(left: switchView.rightAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 20)
        yesLbl.centerVertically(with: self)
        noLbl.anchor(right: switchView.leftAnchor, paddingRight: 4)
        noLbl.centerVertically(with: self)
        
    }
    
    @objc private func toggleSwitch(_ sender: UISwitch) {
        print("The switch has been toggled")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
