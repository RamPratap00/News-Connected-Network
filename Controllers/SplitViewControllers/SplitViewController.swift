//
//  SplitViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 02/01/23.
//

import UIKit

class SplitViewController: UISplitViewController{

    fileprivate let primaryViewController = PrimaryViewController()
    fileprivate let secondaryViewController = SecondaryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewControllers()
        preferredDisplayMode = .secondaryOnly
        // Do any additional setup after loading the view.
    }
    
    private func loadViewControllers() {
            let navController = UINavigationController(rootViewController: primaryViewController)
            let secondaryViewController = UINavigationController(rootViewController: secondaryViewController)
            secondaryViewController.title = "Home"
            primaryViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "list.dash"), target: self, action: nil)
            self.viewControllers = [navController, secondaryViewController]
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
