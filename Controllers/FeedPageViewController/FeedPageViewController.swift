//
//  FeedPageViewController.swift
//  NCN news app
//
//  Created by ram-16138 on 26/12/22.
//
// test new branch
import UIKit

class FeedPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(toLoginPage))
        print(UserDefaults.standard.string(forKey: "EMAIL")!)
        // Do any additional setup after loading the view.
    }
    
    @objc func toLoginPage(){
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
        navigationController?.dismiss(animated: true)
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
