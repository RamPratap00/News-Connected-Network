//
//  CoustomUserTableViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 01/01/23.
//

import UIKit

class CoustomUserTableViewCell: UITableViewCell {

    var nameStamp = UILabel()
    var userIDStamp = UILabel()
    var desStamp = UILabel()
    let img = UIImageView()
    var nonCurrentUserAccount = Account()
    var currentUserAccount = Account()
    let follow = UIButton()
    
    static var identifier = "Cell"
    
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
        nameStamp.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true

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
        desStamp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
        
        // follow button
            follow.setTitle("Follow", for: .normal)
            follow.backgroundColor = .black
            follow.setTitleColor(.white, for: .normal)
            follow.layer.borderColor = UIColor.white.cgColor
            follow.layer.borderWidth = 1
        follow.layer.cornerRadius = 15
        follow.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(follow)
        
        follow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20).isActive = true
        follow.centerYAnchor.constraint(equalTo: img.centerYAnchor).isActive = true
        follow.widthAnchor.constraint(equalToConstant: 120).isActive = true
        follow.addTarget(self, action: #selector(followButtonTapped(sender: )), for: .touchUpInside)

        
    }
    
    func followFollowingButtonSatus(){
        if isFollowing(email: nonCurrentUserAccount.email, followingList: currentUserAccount.followingList){
            follow.setTitle("Following", for: .normal)
            follow.titleLabel?.font = .boldSystemFont(ofSize: 15)
            follow.setTitleColor(.black, for: .normal)
            follow.backgroundColor = .white
            follow.layer.borderWidth = 1
            follow.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func refreshButton(){
        follow.setTitle("Follow", for: .normal)
        follow.titleLabel?.font = .boldSystemFont(ofSize: 15)
        follow.setTitleColor(.white, for: .normal)
        follow.backgroundColor = .black
        follow.layer.borderWidth = 1
        follow.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func followButtonTapped(sender:UIButton){
        
        if sender.currentTitle == "Follow"{
            sender.setTitle("Following", for: .normal)
            sender.titleLabel?.font = .boldSystemFont(ofSize: 15)
            sender.setTitleColor(.black, for: .normal)
            sender.backgroundColor = .white
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.black.cgColor
            nonCurrentUserAccount.followersList.append(currentUserAccount.email)
            currentUserAccount.followingList.append(nonCurrentUserAccount.email)
        }
        else{
            sender.setTitle("Follow", for: .normal)
            sender.titleLabel?.font = .boldSystemFont(ofSize: 15)
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = .black
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.white.cgColor
            if let idx = nonCurrentUserAccount.followersList.firstIndex(of:currentUserAccount.email) {
                nonCurrentUserAccount.followersList.remove(at: idx)
            }
            
            if let idx = currentUserAccount.followingList.firstIndex(of:nonCurrentUserAccount.email) {
                currentUserAccount.followingList.remove(at: idx)
            }
            
        }
        
        updateFireBaseFollowersFollowing(currentUserAccount: currentUserAccount, nonCurrentUserAccount: nonCurrentUserAccount)
        
        
            // intitiate account follow and update following list
         
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFollowing(email: nonCurrentUserAccount.email, followingList: currentUserAccountObject().followingList){
            follow.setTitle("Following", for: .normal)
            follow.titleLabel?.font = .boldSystemFont(ofSize: 15)
            follow.setTitleColor(.black, for: .normal)
            follow.backgroundColor = .white
            follow.layer.borderWidth = 1
            follow.layer.borderColor = UIColor.black.cgColor
        }
        
        if nonCurrentUserAccount.email == currentUserAccount.email{
            follow.isHidden = true
        }
    }

}
