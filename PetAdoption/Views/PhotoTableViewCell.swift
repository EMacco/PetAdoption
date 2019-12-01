//
//  PhotoTableViewCell.swift
//  PetAdoption
//
//  Created by Emmanuel Okwara on 28/11/2019.
//  Copyright © 2019 Emmanuel Okwara. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoTableViewCell: UITableViewCell {
    
    private var elementID: String?
    var formViewModel: IFormViewModel? {
        didSet {
            setCellVisibility()
        }
    }
    var elementInfo: Element? {
        didSet {
            photoImageView.sd_setImage(with: URL(string: elementInfo!.file!), placeholderImage: #imageLiteral(resourceName: "imagePlaceholder"))
            elementID = elementInfo!.uniqueId
        }
    }
    
    private let photoImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 50
        img.backgroundColor = .lightGray
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addSubview(photoImageView)
    }
    
    private func setCellVisibility() {
        if (formViewModel?.isCollapsed(id: elementID!) ?? false) {
            self.isHidden = true
            self.photoImageView.removeAllConstraints()
            self.photoImageView.anchor(top: topAnchor, bottom: bottomAnchor, height: 1)
        } else {
            self.isHidden = false
            self.photoImageView.removeAllConstraints()
            self.addAllConstraints()
        }
    }
    
    private func addAllConstraints() {
        photoImageView.anchor(top: topAnchor, paddingTop: 8, bottom: bottomAnchor, paddingBottom: 8, width: 100, height: 100)
        photoImageView.centerHorizontally(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
