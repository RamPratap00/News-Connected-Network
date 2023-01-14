//
//  ChattingViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController {

    var currentUser = currentUserAccountObject()
    var articleUrl = String()
    var tableView = UITableView()
    var reachableAccounts = [String]()
    var reachableAccountsArray = [Account]()
    let refreshControl = UIRefreshControl()
    var isSharing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        addTableViewOfUsers()
        loadAccountsForChatTableView()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasNetworkConnection(){
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    func loadAccountsForChatTableView(){
        fetchCurrenUserProfileData(completionHandler: {_ in})
        currentUser = currentUserAccountObject()
        let set1:Set<String> = Set(currentUser.followersList)
        let set2:Set<String> = Set(currentUser.followingList)
        reachableAccounts = Array( set1.union(set2) )
        loadDataForTableView(){ status in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadDataForTableView(completionHandler:@escaping (Bool)->()){
        reachableAccountsArray = []
        var count = 0
        for email in reachableAccounts{
            fetchUserProfileData(email: email){ account in
                self.reachableAccountsArray.append(account)
                count+=1
                if count == self.reachableAccounts.count{
                    completionHandler(true)
                }
            }
        }
    }
    
    func addTableViewOfUsers(){
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
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func loadMessages(sendingtUser:Account,comletionHandler:@escaping (String)->()){
        var messages = [Message]()
        fetchMessageFromFireBaseChatSystem(sender: sendingtUser){ documents in
            for document in documents {
                
                let documentData = document.data()
                let timeStamp = documentData["sentDate"] as! Timestamp
                let message = Message(sender: Sender(senderId: documentData["senderId"] as! String, displayName: documentData["displayName"] as! String),
                                      messageId: documentData["messageId"] as! String,
                                      sentDate: timeStamp.dateValue(),
                                      kind: .text(documentData["message"] as! String))
                messages.append(message)
            }
            messages.sort { $0.sentDate<$1.sentDate }
            if messages.count > 0{
                if case .text(let value) = messages[0].kind.self{
                    comletionHandler(value)
                }
            }
            else{
                comletionHandler("")
            }
        }
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        loadAccountsForChatTableView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
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
        return reachableAccountsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CSUserTableViewCell.identifier) as! CSUserTableViewCell
        let account = reachableAccountsArray[indexPath.row]
        cell.nameStamp.text = account.userName
        cell.imageUrl = account.profilePicture
        loadMessages(sendingtUser: account){ lastMessage in
            cell.desStamp.text = lastMessage
        }
        fetchProfilePicture(url: account.profilePicture!){ imageData in
            DispatchQueue.main.async {
                cell.img.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = reachableAccountsArray[indexPath.row]
        let indexesToRedraw = [indexPath]
        tableView.reloadRows(at: indexesToRedraw, with: .fade)
        let nextVC = CSChatViewController()
        nextVC.title = account.userName
        nextVC.sendingtUser = account
        nextVC.receivingUser = currentUser
        if isSharing{
            nextVC.urlToArticle = articleUrl
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.tableView.frame.width,
                                              height: 50))
        let headerLabel = UILabel()
        headerLabel.text = "    Contacts"
        headerLabel.font = .boldSystemFont(ofSize: 30)
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.frame = headerView.bounds
        return headerView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let filterAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
                print("Swiped to delete chat")
                let account = self.reachableAccountsArray[indexPath.row]
                deleteChatFromFireBase(sendingtUser: account){ }
            }
            filterAction.backgroundColor = UIColor.red

            return UISwipeActionsConfiguration(actions: [filterAction])
    }
    
}

