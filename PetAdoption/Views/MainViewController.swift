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
import RxDataSources

class MainViewController: UIViewController {

    var formViewModel: IFormViewModel?
    var formTableViews = [UITableView]()
    let disposeBag = DisposeBag()
    let screenSize = UIScreen.main.bounds
    
    var containerView: UIView!
    var nextBtn: UIButton!
    var currentPage = 1
    var currentXPosition: CGFloat = 0
    var pageWidth = UIScreen.main.bounds.width
    
    convenience init(formViewModel: IFormViewModel) {
        self.init()
        self.formViewModel = formViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        configureViews()
        setupBindings()
        formViewModel?.getPagesTableViewIdentifiers()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation == .portrait {
            pageWidth = screenSize.width
        } else {
            pageWidth = screenSize.height
        }
        
        DispatchQueue.main.async {
            self.scrollTo(page: self.currentPage)
        }
    }
    
    // MARK:- Configure View Elements
    func configureViews() {
        containerView = UIView()
        self.view.addSubview(containerView)
        
        nextBtn = UIButton()
        nextBtn.backgroundColor = UIColor.appColors.red
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action: #selector(self.showNextPage), for: .touchUpInside)
        self.view.addSubview(nextBtn)

        nextBtn.anchor(bottom: self.view.bottomAnchor, paddingBottom: 30, left: self.view.leftAnchor, paddingLeft: 16, right: self.view.rightAnchor, paddingRight: 16, height: 50)
    }
    
    var done = false
    func updateViews() {
        guard done == false else { return }
        done = true
        containerView.anchor(top: self.view.topAnchor, paddingTop: 0, bottom: self.view.bottomAnchor, paddingBottom: 0, left: self.view.leftAnchor, paddingLeft: currentXPosition)
        containerView.equalWidth(with: self.view, multiplier: CGFloat(formTableViews.count))
        
        if formTableViews.count > 1 {
            nextBtn.setTitle("Next", for: .normal)
        } else {
            nextBtn.setTitle("Submit", for: .normal)
        }
    }
    
    // MARK:- Switch between pages
    @objc private func showNextPage() {
        guard currentPage < (formTableViews.count) else { return }
        currentPage += 1
        scrollTo(page: currentPage)
    }
    
    @objc private func showPrevPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
        scrollTo(page: currentPage)
    }
    
    private func scrollTo(page: Int) {
        currentXPosition = -(CGFloat(page - 1) * pageWidth)
        
        if currentPage == formTableViews.count {
            nextBtn.setTitle("Submit", for: .normal)
        } else {
            nextBtn.setTitle("Next", for: .normal)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.containerView.frame.origin.x = self.currentXPosition
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK:- Bind Listeners
    func setupBindings() {
        formViewModel?.pagesTableViewIdentifiers.bind { [weak self] pagesConfigurations in
            for (pageIndex, page) in pagesConfigurations.enumerated() {
                self?.configureFormPageWithCells(name: page.name, config: page.identifiers, index: pageIndex)
                if let pageView = self?.formTableViews[pageIndex] {
                    self?.bindDataSourceTo(page: pageView, dataSource: page.dataSource)
                }
            }
            
            self?.updateViews()
        }.disposed(by: disposeBag)
    }

    private func bindDataSourceTo(page tableView: UITableView, dataSource: [SectionModel<String, Element>]) {
        let tableViewObservable = Observable.just(dataSource)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Element>>(configureCell: { dataSource, table, indexPath, item in
            switch item.type {
                case .dateTime, .formattedNumeric, .text:
                    let cell = table.dequeueReusableCell(withIdentifier: item.type.rawValue) as! TextTableViewCell
                    cell.elementInfo = item
                    cell.tableView = table
                    cell.formViewModel = self.formViewModel
                    return cell
                case .embeddedPhoto:
                    let cell = table.dequeueReusableCell(withIdentifier: item.type.rawValue) as! PhotoTableViewCell
                    cell.elementInfo = item
                    cell.formViewModel = self.formViewModel
                    return cell
                case .yesNo:
                    let cell = table.dequeueReusableCell(withIdentifier: item.type.rawValue) as! OptionTableViewCell
                    cell.elementInfo = item
                    cell.allPagesTableViews = self.formTableViews
                    cell.formViewModel = self.formViewModel
                    return cell
                default:
                    let cell = UITableViewCell()
                    cell.textLabel?.text = "Cell could not be found"
                    cell.backgroundColor = .red
                    return cell
            }
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
          return dataSource.sectionModels[index].model
        }
        tableViewObservable.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.hideKeyboard()
        }).disposed(by: disposeBag)
    }
    
    // MARK:- Hide Keyboard
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    // MARK:- Create Form Pages
    private func configureFormPageWithCells(name pageName: String, config identifiers: [ElementType], index pageIndex: Int) {
        let tableView = createTableView(with: identifiers)
        let titleLbl = createTitleLbl(name: pageName)
        let backBtn = createBackBtn(index: pageIndex)
        
        backBtn?.anchor(bottom: titleLbl.bottomAnchor, paddingBottom: 8, left: tableView.leftAnchor, paddingLeft: 16, width: 40, height: 40)
        
        titleLbl.anchor(top: containerView.topAnchor, paddingTop: 0, left: tableView.leftAnchor, paddingLeft: 0, right: tableView.rightAnchor, paddingRight: 0, height: 100)
        
        tableView.anchor(top: titleLbl.bottomAnchor, paddingTop: 0, bottom: nextBtn.topAnchor, paddingBottom: 18)
        tableView.equalWidth(with: self.view, multiplier: 1)
        
        if formTableViews.count > 0 && pageIndex > 0 {
            let previousView = self.formTableViews[pageIndex-1]
            tableView.anchor(left: previousView.rightAnchor, paddingLeft: 0)
        } else {
            tableView.anchor(left: containerView!.leftAnchor, paddingLeft: 0, width: pageWidth)
        }
        
        self.formTableViews.append(tableView)
    }
    
    private func createBackBtn(index: Int) -> UIButton? {
        if index > 0 {
            let backBtn = UIButton()
            backBtn.setImage(#imageLiteral(resourceName: "backBtn"), for: .normal)
            backBtn.addTarget(self, action: #selector(self.showPrevPage), for: .touchUpInside)
            self.containerView?.addSubview(backBtn)
            return backBtn
        }
        
        return nil
    }
    
    private func createTitleLbl(name pageName: String) -> UILabel {
        let titleLbl = UILabel()
        titleLbl.text = "\n\n\(pageName)"
        titleLbl.numberOfLines = 3
        titleLbl.backgroundColor = UIColor.appColors.red
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        
        self.containerView?.addSubview(titleLbl)
        return titleLbl
    }
    
    private func createTableView(with identifiers: [ElementType]) -> UITableView {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tableView.addGestureRecognizer(tap)
        
        for identifier in identifiers {
            tableView = self.registerCellWithIdentifier(tableView: tableView, identifier: identifier)
        }
        
        self.containerView?.addSubview(tableView)
        return tableView
    }
    
    // MARK:- Register TableViewCells
    private func registerCellWithIdentifier(tableView: UITableView, identifier: ElementType) -> UITableView {
        switch identifier {
        case .dateTime, .text, .formattedNumeric:
            tableView.register(TextTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .embeddedPhoto:
            tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        case .yesNo:
            tableView.register(OptionTableViewCell.self, forCellReuseIdentifier: identifier.rawValue)
            break
        default:
            break
        }
        return tableView
    }
}
