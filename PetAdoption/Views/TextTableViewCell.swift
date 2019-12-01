//
//  TextTableViewCell.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 28/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import UIKit
import RxSwift

class TextTableViewCell: UITableViewCell {
    private var elementID: String?
    var tableView: UITableView?
    let disposeBag = DisposeBag()
    
    // MARK:- Create View Elements
    var elementInfo: Element? {
        didSet {
            elementID = elementInfo!.uniqueId
            titleLbl.text = elementInfo!.label
            setKeyboardType(type: elementInfo!.keyboard ?? KeyboardType.normal)
            if let mode = elementInfo!.mode {
                setPickerView(type: mode, options: elementInfo?.options)
            }
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColors.lightGray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private let textField: UITextField  = {
        let field = UITextField()
        field.text = ""
        field.font = .systemFont(ofSize: 15)
        return field
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        label.textColor = .darkGray
        label.font = label.font.withSize(12)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK:- Configure Views and constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addSubview(containerView)
        addSubview(textField)
        addSubview(titleLbl)
        
        containerView.anchor(top: topAnchor, paddingTop: 20, bottom: bottomAnchor, paddingBottom: 20, left: leftAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: 20)
        titleLbl.anchor(top: containerView.topAnchor, paddingTop: 8, bottom: textField.topAnchor, paddingBottom: 8, left: containerView.leftAnchor, paddingLeft: 8, right: containerView.rightAnchor, paddingRight: 8)
        textField.anchor(bottom: containerView.bottomAnchor, paddingBottom: 8, left: containerView.leftAnchor, paddingLeft: 8, right: containerView.rightAnchor, paddingRight: 8, height: 30)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- Keyboard visibility
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let _ = notification.userInfo {
            if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
                self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.tableView?.contentInset = UIEdgeInsets.zero
        }
    }
    
    private func setKeyboardType(type: KeyboardType) {
        switch type {
            case .email:
                textField.keyboardType = .emailAddress
            case .numeric:
                textField.keyboardType = .phonePad
            case .password:
                textField.isSecureTextEntry = true
            default:
                textField.keyboardType = .default
        }
    }
    
    // MARK:- Pickerview configuration
    private func setPickerView(type: Mode, options: [String]?) {
        switch type {
            case .date:
                bindDatePickerView()
            case .select:
                bindPickerView(data: options ?? [])
            default:
                textField.keyboardType = .default
        }
    }
    
    private func bindDatePickerView() {
        let datePicker = UIDatePicker()
        let mode = UIDatePicker.Mode(rawValue: 1)
        datePicker.datePickerMode = mode!
        self.textField.inputView = datePicker
        datePicker.maximumDate = Date()
        
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(_:)), for: .valueChanged)
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textField.text = formatter.string(from: sender.date)
    }
    
    private func bindPickerView(data: [String]) {
        let picker = UIPickerView()
        Observable.just(data).bind(to: picker.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)
        
        picker.rx.itemSelected.subscribe({ [weak self] event in
            self?.textField.text = data[event.element?.row ?? 0]
        }).disposed(by: disposeBag)
        
        textField.inputView = picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
