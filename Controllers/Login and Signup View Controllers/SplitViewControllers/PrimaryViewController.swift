//
//  PrimaryViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 30/12/22.
//

import UIKit
import FirebaseAuth

class PrimaryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSignOutButton()
        addViewProfileButton()
        if UIDevice.current.userInterfaceIdiom != .pad{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(toMainPage))
        }
    }
    
    
    func reloadProfileData(){
        fetchCurrenUserProfileData(completionHandler: {_ in})
    }
    
    func addViewProfileButton(){
        
        let userData = UserDefaults.standard.value(forKey: "USERMETADATA") as! [String:Any]?
        let account = Account()
        account.userName = userData?["USERNAME"] as! String
        account.profileDescription = userData?["PROFILE_DESCRIPTION"] as! String
        account.profilePicture = URL(string: userData?["URL_TO_PROFILE_PICTURE"] as! String)!
        account.email = userData?["EMAIL"] as! String
        
        let profilePicture = UIButton()
        let nameLabel = UILabel()
        let userIdLabel = UILabel()
        let profileImageData = UserDefaults.standard.object(forKey: "PROFILEPICTURE") as! Data
        
        view.addSubview(profilePicture)
        profilePicture.setImage(UIImage(data: profileImageData), for: .normal)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: view.topAnchor,constant:100).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profilePicture.layer.cornerRadius = 75
        profilePicture.layer.masksToBounds = true
        profilePicture.addTarget(self, action: #selector(profileDetailView), for: .touchUpInside)
        
        view.addSubview(nameLabel)
        nameLabel.text = account.userName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor,constant:5).isActive = true
        nameLabel.textAlignment = .center
        
        view.addSubview(userIdLabel)
        userIdLabel.text = account.fetchUserID()
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        userIdLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userIdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant:-25).isActive = true
        userIdLabel.textAlignment = .center
        
        /// need to add description with edit button
        
        
    }
    
    @objc func profileDetailView(){
        let nextVC = ProfileViewController()
        nextVC.email = UserDefaults.standard.value(forKey: "EMAIL") as! String
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func addSignOutButton(){
        let signOutButton = UIButton()
        view.addSubview(signOutButton)
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(UIColor.red, for: .normal)
        signOutButton.titleLabel?.font = .systemFont(ofSize: 17)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier:0.9).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:-80).isActive = true
        signOutButton.addTarget(self, action: #selector(toLoginPage), for: .touchUpInside)
    }
    
    @objc func toLoginPage(){
        if UserDefaults.standard.bool(forKey: "ISLOGGEDIN"){
            try! FirebaseAuth.Auth.auth().signOut()
            print("signed out")
        }
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
        navigationController?.dismiss(animated: false)
    }
    
    @objc func toMainPage(){
        let nextVC = SecondaryViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

