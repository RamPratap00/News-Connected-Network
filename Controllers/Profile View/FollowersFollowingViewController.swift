//
//  FollowersFollowingViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 11/01/23.
//

import UIKit

class FollowersFollowingViewController: UIViewController {

    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    var account = Account()
    var accountList = [String]()
    var arrayOfAccounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTableView()
        reloadAccountDataForTableView()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        reloadAccountDataForTableView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func reloadAccountDataForTableView(){
        arrayOfAccounts = []
        tableView.reloadData()
        
        fetchArrayOfAccounts(emailArray: accountList){ accounts in
            self.arrayOfAccounts = accounts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func addTableView(){
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.register(CoustomUserTableViewCell.self, forCellReuseIdentifier: CoustomUserTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
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

extension FollowersFollowingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayOfAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CoustomUserTableViewCell.identifier, for: indexPath) as! CoustomUserTableViewCell
        let account = arrayOfAccounts[indexPath.row]
            cell.currentUserAccount = currentUserAccountObject()
            cell.nameStamp.text = account.userName
            cell.userIDStamp.text = account.fetchUserID()
            cell.desStamp.text = account.profileDescription
        
        cell.nonCurrentUserAccount = account
            fetchProfilePicture(url: account.profilePicture!){ imageData in
                DispatchQueue.main.async{
                    cell.img.image = UIImage(data: imageData)
                }
            }
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVC = ProfileViewController()
        fetchUserProfileData(email: arrayOfAccounts[indexPath.row].email){ account in
            nextVC.nonCurrentUser = account
            let indexesToRedraw = [indexPath]
            tableView.reloadRows(at: indexesToRedraw, with: .fade)
                self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}
