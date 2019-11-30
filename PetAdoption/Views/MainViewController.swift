//
//  MainViewController.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 27/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    var formViewModel: IFormViewModel?
    var formTableViews = [UITableView]()
    let disposeBag = DisposeBag()
    let screenSize = UIScreen.main.bounds
    
    var containerView: UIView!
    var nextBtn: UIButton!
    var currentPage = 1
    var currentXPosition: CGFloat = 0
    
    convenience init(formViewModel: IFormViewModel) {
        self.init()
        self.formViewModel = formViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        setupBindings()
        formViewModel?.getPagesTableViewIdentifiers()
    }
    
    // MARK:- Configure View Elements
    func configureViews() {
        containerView = UIView()
        self.view.addSubview(containerView)
        
        nextBtn = UIButton()
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.backgroundColor = UIColor.appColors.green
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action: #selector(self.showNextPage), for: .touchUpInside)
        self.view.addSubview(nextBtn)

        nextBtn.anchor(bottom: self.view.bottomAnchor, paddingBottom: 30, left: self.view.leftAnchor, paddingLeft: 16, right: self.view.rightAnchor, paddingRight: 16, height: 50)
    }
    
    func updateViews() {
        containerView.anchor(top: self.view.topAnchor, paddingTop: 50, bottom: self.view.bottomAnchor, paddingBottom: 0, left: self.view.leftAnchor, paddingLeft: currentXPosition, width: screenSize.width * CGFloat(formTableViews.count))
        
    }
    
    @objc private func showNextPage() {
        guard currentPage < (formTableViews.count) else { return }
        scrollView(next: true)
        currentPage += 1
    }
    
    @objc private func showPrevPage() {
        guard currentPage > 0 else { return }
        scrollView(next: false)
        currentPage -= 1
    }
    
    private func scrollView(next: Bool) {
        if next {
            currentXPosition -= self.screenSize.width
        } else {
            currentXPosition += self.screenSize.width
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.containerView.frame.origin.x = self.currentXPosition
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK:- Bind Listeners
    func setupBindings() {
        formViewModel?.pagesTableViewIdentifiers.bind { [weak self] pagesIdentifiers in
            var pageIndex = 0
            for page in pagesIdentifiers {
                self?.configureFormPageWithCells(name: page.name, config: page.identifiers, index: pageIndex)
                pageIndex += 1
            }
            
            // Bind the individual pages
            
            // Trigger the update
            
            self?.setupPages()
        }.disposed(by: disposeBag)
    }
    
    private func setupPages() {
        
        
        updateViews()
    }
    
    // MARK:- Create TableViews
    private func configureFormPageWithCells(name pageName: String, config identifiers: [ElementType], index pageIndex: Int) {
        var tableView = UITableView()
        let titleLbl = UILabel()
        let backBtn = UIButton()
        titleLbl.text = pageName
        titleLbl.backgroundColor = .brown
        titleLbl.textColor = .white
        
        backBtn.setImage(#imageLiteral(resourceName: "backBtn"), for: .normal)
        
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        for identifier in identifiers {
            tableView = self.registerCellWithIdentifier(tableView: tableView, identifier: identifier)
        }
        
        self.containerView?.addSubview(tableView)
        self.containerView?.addSubview(titleLbl)
        
        if pageIndex > 0 {
            backBtn.addTarget(self, action: #selector(self.showPrevPage), for: .touchUpInside)
            self.containerView.addSubview(backBtn)
            backBtn.anchor(top: containerView.topAnchor, paddingTop: 6, left: tableView.leftAnchor, paddingLeft: 16, width: 40, height: 40)
        }
        
        titleLbl.anchor(top: containerView.topAnchor, paddingTop: 0, left: tableView.leftAnchor, paddingLeft: 0, right: tableView.rightAnchor, paddingRight: 0, height: 50)
        titleLbl.textAlignment = .center
        
        var previousView = containerView!
        var leftPadding: CGFloat = 0
        if formTableViews.count > 0 {
            previousView = self.formTableViews[pageIndex-1]
            leftPadding = screenSize.width
        }
        
        tableView.anchor(top: titleLbl.bottomAnchor, paddingTop: 16, bottom: nextBtn.topAnchor, paddingBottom: 18, left: previousView.leftAnchor, paddingLeft: leftPadding, width: screenSize.width)
        
        self.formTableViews.append(tableView)
    }
    
    // MARK:- Register TableViewCells
    private func registerCellWithIdentifier(tableView: UITableView, identifier: ElementType) -> UITableView {
        switch identifier {
        case .dateTime:
            tableView.register(DateTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .embeddedPhoto:
            tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .formattedNumeric:
            tableView.register(FormattedNumericTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .text:
            tableView.register(TextTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .yesNo:
            tableView.register(OptionTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .sectionTitle:
            tableView.register(SectionTitleTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        default:
            break
        }
        return tableView
    }

}
