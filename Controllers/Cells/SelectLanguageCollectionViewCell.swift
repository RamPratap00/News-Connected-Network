//
//  SelectLanguageCollectionViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 08/01/23.
//

import UIKit

class SelectLanguageCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "language cell"
    var cellTapCount = 0
    var languageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(languageLabel)
        languageLabel.backgroundColor = .systemBackground
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.frame = contentView.bounds
        languageLabel.layer.cornerRadius = 30
        languageLabel.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        languageLabel.layer.masksToBounds = true
        languageLabel.layer.borderWidth = 2
        
    }

}
