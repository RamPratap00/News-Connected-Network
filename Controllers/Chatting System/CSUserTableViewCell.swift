//
//  CSUserTableViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 06/01/23.
//

import UIKit

class CSUserTableViewCell: UITableViewCell {

    static let identifier = "CSUserCell"
    var nameStamp = UILabel()
    var userIDStamp = UILabel()
    var desStamp = UILabel()
    var imageUrl : URL?
    let img = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        img.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(img)
        img.widthAnchor.constraint(equalToConstant: 60).isActive = true
        img.heightAnchor.constraint(equalToConstant: 60).isActive = true
        img.layer.cornerRadius = 30
        img.layer.masksToBounds = true
        img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        img.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        // load name
        contentView.addSubview(nameStamp)
        nameStamp.translatesAutoresizingMaskIntoConstraints = false
        nameStamp.font = .boldSystemFont(ofSize: 20)
        nameStamp.leadingAnchor.constraint(equalTo: img.trailingAnchor,constant: 10).isActive = true
        nameStamp.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15).isActive = true

        contentView.addSubview(userIDStamp)
        userIDStamp.translatesAutoresizingMaskIntoConstraints = false
        userIDStamp.font = .systemFont(ofSize: 15)
        userIDStamp.topAnchor.constraint(equalTo: nameStamp.bottomAnchor).isActive = true
        userIDStamp.leadingAnchor.constraint(equalTo: nameStamp.leadingAnchor).isActive = true
        
        contentView.addSubview(desStamp)
        desStamp.translatesAutoresizingMaskIntoConstraints = false
        desStamp.numberOfLines = 0
        desStamp.font = .systemFont(ofSize: 12)
        desStamp.leadingAnchor.constraint(equalTo: nameStamp.leadingAnchor).isActive = true
        desStamp.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        desStamp.topAnchor.constraint(equalTo: userIDStamp.bottomAnchor).isActive = true
        desStamp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -15).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
