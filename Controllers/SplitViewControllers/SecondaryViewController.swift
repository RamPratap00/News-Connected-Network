//
//  SecondaryViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 02/01/23.
//

import UIKit
import FirebaseAuth

class SecondaryViewController: UITabBarController,UITabBarControllerDelegate {

    let currentUserEmail = UserDefaults.standard.string(forKey: "EMAIL")!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        delegate = self
        
        let item1 = TrendingPageViewController()
        let item2 = SearchUsersAndNewsViewController()
        let item3 = RecentActivityOnMyNetworkViewController()
        let item4 = ChattingViewController()
        let icon1 = UITabBarItem(title: "Trending", image: UIImage(systemName: "newspaper"), tag: 0)
        let icon2 = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let icon3 = UITabBarItem(title: "Network", image: UIImage(systemName: "bonjour"), tag: 2)
        let icon4 = UITabBarItem(title: "Chat", image: UIImage(systemName: "ellipsis.bubble"), tag: 3)
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        item3.tabBarItem = icon3
        item4.tabBarItem = icon4
        let controllers = [item3,item2,item1,item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        }

    //Delegate methods
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            return true;
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
