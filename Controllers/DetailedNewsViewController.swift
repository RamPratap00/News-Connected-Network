//
//  DetailedNewsViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 04/01/23.
//

import UIKit

class DetailedNewsViewController: UIViewController {

    var article = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addPushButton()
        // Do any additional setup after loading the view.
    }
    
    func addPushButton(){
        let button = UIButton()
        button.setTitle("Push this to users recent activity", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStamp), for: .touchUpInside)
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStamp(){
        print("updating recent activity stack")
        updateFireBaseRecentActivityStack(article: article,reaction: "neutral")
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


