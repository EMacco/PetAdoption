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
    var formViewModel: IFormViewModel? {
        didSet {
            setCellVisibility()
            populateField()
        }
    }
    
    // MARK:- Create View Elements
    var elementInfo: Element? {
        didSet {
            elementID = elementInfo!.uniqueId
            titleLbl.text = elementInfo!.label
            setKeyboardType(type: elementInfo!.keyboard ?? KeyboardType.normal)
            if let mode = elementInfo!.mode {
                setPickerView(type: mode, options: elementInfo?.options)
            } else {
                textField.inputView = nil
                textField.reloadInputViews()
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
    
    private let requiredLbl: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor.appColors.red
        return label
    }()
    
    // MARK:- Configure Views and constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addSubview(containerView)
        addSubview(textField)
        addSubview(titleLbl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textField.rx.text.subscribe(onNext: { [weak self] text in
            self?.updateUserInput(text: text)
        }).disposed(by: disposeBag)
        
        textField.delegate = self
    }
    
    private func updateUserInput(text: String?) {
        formViewModel?.updateUserInput(id: elementID!, value: text)
    }
    
    private func populateField() {
        textField.text = formViewModel?.getUserInput(id: elementID!) ?? ""
    }
    
    private func setCellVisibility() {
        if (formViewModel?.isCollapsed(id: elementID!) ?? false) {
            self.isHidden = true
            self.containerView.removeAllConstraints()
            self.containerView.anchor(top: topAnchor, bottom: bottomAnchor, height: 1)
        } else {
            self.isHidden = false
            self.containerView.removeAllConstraints()
            self.addAllConstraints()
        }
    }
    
    private func addAllConstraints() {
        containerView.anchor(top: topAnchor, paddingTop: 20, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: 20)
        titleLbl.anchor(top: containerView.topAnchor, paddingTop: 8, bottom: textField.topAnchor, paddingBottom: 8, right: containerView.rightAnchor, paddingRight: 8)
        textField.anchor(bottom: containerView.bottomAnchor, paddingBottom: 8, left: containerView.leftAnchor, paddingLeft: 8, right: containerView.rightAnchor, paddingRight: 8, height: 30)
        
        let mandatory = elementInfo?.isMandatory ?? false
        if mandatory {
            containerView.addSubview(requiredLbl)
            requiredLbl.anchor(top: containerView.topAnchor, paddingTop: 12, left: containerView.leftAnchor, paddingLeft: 8, width: 10, height: 10)
            titleLbl.anchor(left: containerView.leftAnchor, paddingLeft: 18)
        } else {
            requiredLbl.removeFromSuperview()
            titleLbl.anchor(left: containerView.leftAnchor, paddingLeft: 8)
        }
    }
    
    // MARK:- Keyboard visibility
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let _ = notification.userInfo {
            if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
                self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 80, right: 0)
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

// MARK:- TableView Delegate
extension TextTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = self.elementInfo?.formattedNumeric {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            let pattern = self.elementInfo!.formattedNumeric!
            guard let text = self.textField.text else { return false }
            self.textField.text = text.formatPhoneNumber(pattern: pattern, replacementCharacter: "#")
            return count <= pattern.count
        }
        return true
    }
}
