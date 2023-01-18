//
//  CoustomUserTableViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 01/01/23.
//

import UIKit

class CoustomUserTableViewCell: UITableViewCell {

    public var nameStamp = UILabel()
    public var userIDStamp = UILabel()
    public var desStamp = UILabel()
    public let img = UIImageView()
    public var nonCurrentUserAccount = Account()
    public var currentUserAccount = Account()
    fileprivate let follow = UIButton()
    
    static var identifier = "Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
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
        nameStamp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameStamp.widthAnchor.constraint(equalToConstant: 250).isActive = true

        contentView.addSubview(userIDStamp)
        userIDStamp.translatesAutoresizingMaskIntoConstraints = false
        userIDStamp.font = .systemFont(ofSize: 15)
        userIDStamp.topAnchor.constraint(equalTo: nameStamp.bottomAnchor).isActive = true
        userIDStamp.leadingAnchor.constraint(equalTo: nameStamp.leadingAnchor).isActive = true
        userIDStamp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userIDStamp.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        contentView.addSubview(desStamp)
        desStamp.translatesAutoresizingMaskIntoConstraints = false
        desStamp.font = .systemFont(ofSize: 12)
        desStamp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        desStamp.leadingAnchor.constraint(equalTo: nameStamp.leadingAnchor).isActive = true
        desStamp.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
        desStamp.topAnchor.constraint(equalTo: userIDStamp.bottomAnchor).isActive = true
        desStamp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
        
        // follow button
        follow.layer.borderColor = UIColor.white.cgColor
        follow.layer.borderWidth = 1
        follow.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        follow.layer.cornerRadius = 12
        contentView.addSubview(follow)
        follow.translatesAutoresizingMaskIntoConstraints = false
        follow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20).isActive = true
        follow.centerYAnchor.constraint(equalTo: img.centerYAnchor).isActive = true
        follow.widthAnchor.constraint(equalToConstant: 120).isActive = true
        follow.addTarget(self, action: #selector(followButtonTapped(sender: )), for: .touchUpInside)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        else{
            follow.setTitle("Follow", for: .normal)
            follow.titleLabel?.font = .boldSystemFont(ofSize: 15)
            follow.setTitleColor(.white, for: .normal)
            follow.backgroundColor = .black
            follow.layer.borderWidth = 1
            follow.layer.borderColor = UIColor.white.cgColor
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
    
    @objc func followButtonTapped(sender:UIButton){
        
        var removeFlag = false
        if sender.currentTitle == "Follow" {
            sender.setTitle("Following", for: .normal)
            sender.titleLabel?.font = .boldSystemFont(ofSize: 15)
            sender.setTitleColor(.black, for: .normal)
            sender.backgroundColor = .white
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.black.cgColor
        }
        else{
            sender.setTitle("Follow", for: .normal)
            sender.titleLabel?.font = .boldSystemFont(ofSize: 15)
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = .black
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.white.cgColor
            removeFlag = true
        }
        
        
        fetchUserProfileData(isCurrentUser: true, email: currentUserAccount.email){ currentUserFetchStatus in
            fetchUserProfileData(isCurrentUser: false, email: self.nonCurrentUserAccount.email){ newNonCurrentUser in
                self.currentUserAccount = currentLoggedInUserAccount()
                self.nonCurrentUserAccount = newNonCurrentUser
                if !isFollowing(email: self.nonCurrentUserAccount.email, followingList: self.currentUserAccount.followingList){
                    self.nonCurrentUserAccount.followersList.append(self.currentUserAccount.email)
                    self.currentUserAccount.followingList.append(self.nonCurrentUserAccount.email)
                    updateFireBaseFollowersFollowing(currentUserAccount: self.currentUserAccount, nonCurrentUserAccount: self.nonCurrentUserAccount)
                }
                if removeFlag{
                    if let idx = self.nonCurrentUserAccount.followersList.firstIndex(of:self.currentUserAccount.email) {
                        self.nonCurrentUserAccount.followersList.remove(at: idx)
                    }
                    
                    if let idx = self.currentUserAccount.followingList.firstIndex(of:self.nonCurrentUserAccount.email) {
                        self.currentUserAccount.followingList.remove(at: idx)
                    }
                    updateFireBaseFollowersFollowing(currentUserAccount: self.currentUserAccount, nonCurrentUserAccount: self.nonCurrentUserAccount)
                }
                
            }
        }
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        followFollowingButtonSatus()
        
        
        if nonCurrentUserAccount.email == currentUserAccount.email{
            follow.isHidden = true
        }
    }

}
