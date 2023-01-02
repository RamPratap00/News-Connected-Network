//
//  SearchUsersAndNewsViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class SearchUsersAndNewsViewController: UIViewController, UITableViewDelegate {

    let peopleTableView = UITableView()
    let currentUserAccount = currentUserAccountObject()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSegementControl()
        addUserTableView()
        fetchUsersForRecomendation(){_ in}
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUsersForRecomendation(){_ in
            
            self.peopleTableView.reloadData()
        }
    }
    
    func addSegementControl(){
        let segmentItems = ["News", "People"]
        let control = UISegmentedControl(items: segmentItems)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        view.addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        control.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier:0.9).isActive = true
        control.heightAnchor.constraint(equalToConstant: 50).isActive = true
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        peopleTableView.isHidden = true
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
           peopleTableView.isHidden = true
           print("news")
             // First segment tapped
          break
          case 1:
           peopleTableView.isHidden = false
             // Second segment tapped
          break
          default:
          break
       }
    }
    
    
    func addUserTableView(){
        view.addSubview(peopleTableView)
        peopleTableView.translatesAutoresizingMaskIntoConstraints = false
        peopleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:60).isActive = true
        peopleTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        peopleTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        peopleTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        peopleTableView.register(CoustomUserTableViewCell.self, forCellReuseIdentifier: CoustomUserTableViewCell.identifier)
        peopleTableView.estimatedRowHeight = 100
        peopleTableView.rowHeight = UITableView.automaticDimension
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
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

extension SearchUsersAndNewsViewController:UITableViewDataSource,UITextViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return ArrayOfAccountsAndNews.recomendedAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: CoustomUserTableViewCell.identifier, for: indexPath) as! CoustomUserTableViewCell
            let account = ArrayOfAccountsAndNews.recomendedAccounts[indexPath.row]
            cell.currentUserAccount = currentUserAccount
        cell.nameStamp.text = account.userName
        cell.userIDStamp.text = account.fetchUserID()
        cell.desStamp.text = account.profileDescription
            fetchUserProfileData(email:account.email ){ nonCurrentUserAccount in
                cell.nonCurrentUserAccount = nonCurrentUserAccount
            }
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
        nextVC.email = ArrayOfAccountsAndNews.recomendedAccounts[indexPath.row].email
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
