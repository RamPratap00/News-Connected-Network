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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(toMainPage))
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

