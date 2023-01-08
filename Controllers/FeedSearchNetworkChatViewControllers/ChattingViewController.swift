//
//  ChattingViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class ChattingViewController: UIViewController {

    var currentUser = currentUserAccountObject()
    let tableView = UITableView()
    var reachableAccounts = [String]()
    var reachableAccountsArray = [Account]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchCurrenUserProfileData(completionHandler: {_ in})
        currentUser = currentUserAccountObject()
        let set1:Set<String> = Set(currentUser.followersList)
        let set2:Set<String> = Set(currentUser.followingList)
        reachableAccounts = Array( set1.union(set2) )
        addTableViewOfUsers()
        loadDataForTableView()
        // Do any additional setup after loading the view.
    }

    
    func loadDataForTableView(){
        reachableAccountsArray = []
        var count = 0
        for email in reachableAccounts{
            fetchUserProfileData(email: email){ account in
                self.reachableAccountsArray.append(account)
                count+=1
                if count == self.reachableAccounts.count{
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func addTableViewOfUsers(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo:view.widthAnchor ).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CSUserTableViewCell.self, forCellReuseIdentifier: CSUserTableViewCell.identifier)
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


extension ChattingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reachableAccountsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSUserTableViewCell.identifier) as! CSUserTableViewCell
        let account = reachableAccountsArray[indexPath.row]
        cell.userIDStamp.text = account.fetchUserID()
        cell.nameStamp.text = account.userName
        fetchProfilePicture(url: account.profilePicture!){ imageData in
            DispatchQueue.main.async {
                cell.img.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = reachableAccountsArray[indexPath.row]
        let nextVC = CSChatViewController()
        nextVC.sendingtUser = account
        nextVC.receivingUser = currentUser
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
