//
//  SecondaryViewController.swift
//  NCN news app
//
//  Created by ram-16138 on 26/12/22.
//
// test new branch
import UIKit
import FirebaseAuth

class SecondaryViewController: UIViewController {

    let currentUserEmail = UserDefaults.standard.string(forKey: "EMAIL")!
    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }
    
    
    
    
//    func tab(){
//        let item1 = UITabBarItem(title: "Trending", image: UIImage(systemName: "newspaper"), tag: 0)
//        let item2 = UITabBarItem(tabBarSystemItem: .search, tag: 1)
//        //let item3 = UITabBarItem(title: "podcast", image: UIImage(systemName: "mic"), tag: 3)
//        let item3 = UITabBarItem(title: "Network", image: UIImage(systemName: "bonjour"), tag: 2)
//        let item4 = UITabBarItem(title: "Chat", image: UIImage(systemName: "ellipsis.bubble"), tag: 3)
//
//        feedPage.tabBarItem = item1
//        item1.badgeColor = .systemGray
//
//        search.tabBarItem = item2
//        item2.badgeColor = .systemGray
//        //search.view.backgroundColor = .white
//
//        notification.tabBarItem = item3
//        item3.badgeColor = .systemGray
//        //notification.view.backgroundColor = .white
//
//        message.tabBarItem = item4
//        item4.badgeColor = .systemGray
//        //message.view.backgroundColor = .white
//
//        tabBar.viewControllers = [feedPage,search,podcast,notification,message]
//        view.addSubview(tabBar.view)
//        tabBar.tabBar.frame.size.height = CGFloat(150)
//        tabBar.tabBar.backgroundColor = .systemBackground
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


