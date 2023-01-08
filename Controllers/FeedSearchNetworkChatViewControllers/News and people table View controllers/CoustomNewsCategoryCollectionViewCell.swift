//
//  CoustomNewsCategoryCollectionViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import UIKit

class CoustomNewsCategoryCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "Cell"
    var newsCategory = UIButton()
    var nameOfTheCategory = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(newsCategory)
        newsCategory.backgroundColor = .systemBackground
        newsCategory.translatesAutoresizingMaskIntoConstraints = false
        newsCategory.frame = contentView.bounds
        newsCategory.layer.cornerRadius = 30
        newsCategory.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        newsCategory.layer.masksToBounds = true
        newsCategory.titleLabel?.font = .boldSystemFont(ofSize: 30)
    }
    
}
