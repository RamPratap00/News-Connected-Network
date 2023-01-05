//
//  ProfileViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 01/01/23.
//

import UIKit

class ProfileViewController: UIViewController {

    var email = String()
    let data = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temp()
        // Do any additional setup after loading the view.
    }
    
    func temp(){
        
        fetchUserProfileData(email: email){ account in
            self.data.text = "following \(account.followingList.count), follower \(account.followersList.count) and Recent Activity \(account.recentActivityCount)"
        }
        
        data.textAlignment = .center
        view.addSubview(data)
        data.translatesAutoresizingMaskIntoConstraints = false
        data.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        data.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        data.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        data.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
