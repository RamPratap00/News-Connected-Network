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
        view.backgroundColor = .systemBackground
        tab()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func tab(){
        let item1 = UITabBarItem(title: "Trending", image: UIImage(systemName: "newspaper"), tag: 0)
        let item2 = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let item3 = UITabBarItem(title: "Network", image: UIImage(systemName: "bonjour"), tag: 2)
        let item4 = UITabBarItem(title: "Chat", image: UIImage(systemName: "ellipsis.bubble"), tag: 3)

        let feedPage = FeedPageViewController()
        feedPage.tabBarItem = item1
        item1.badgeColor = .systemGray

        let search = SearchUsersAndNewsViewController()
        search.tabBarItem = item2
        item2.badgeColor = .systemGray
        //search.view.backgroundColor = .white

        let recentActivity = RecentActivityOnMyNetworkViewController()
        recentActivity.tabBarItem = item3
        item3.badgeColor = .systemGray
        //notification.view.backgroundColor = .white

        let message = ChattingViewController()
        message.tabBarItem = item4
        item4.badgeColor = .systemGray
        //message.view.backgroundColor = .white

        tabBar.viewControllers = [feedPage,search,recentActivity,message]
        view.addSubview(tabBar.view)
        tabBar.tabBar.backgroundColor = .systemBackground
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        tabBar.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabBar.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tabBar.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabBar.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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


