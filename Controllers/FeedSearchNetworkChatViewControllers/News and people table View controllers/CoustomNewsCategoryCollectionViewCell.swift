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
    
    func textToImage(drawText text: String, inImage image: UIImage) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(origin: CGPoint(x: contentView.frame.midX, y: contentView.frame.midY), size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
}
