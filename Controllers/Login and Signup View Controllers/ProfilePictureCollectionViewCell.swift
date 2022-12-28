//
//  ProfilePictureCollectionViewCell.swift
//  NCN news app
//
//  Created by ram-16138 on 25/12/22.
//
/// THIS VIEW CONTROLLER IS USED TO SETUP THE CUSTOM CELL FOR PROFILE PICTURE
import UIKit

class ProfilePictureCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "profile picture cell"
    var cellTapCount = 0
    var profileImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(profileImage)
        profileImage.backgroundColor = .systemBackground
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.frame = contentView.bounds
        profileImage.layer.cornerRadius = 30
        profileImage.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 4
        
    }
    
}
