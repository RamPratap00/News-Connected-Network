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
    let segmentItems = ["News", "People"]
    let newsCategory = ["Arts","Buisness","Crime","Education","Investigation","Politics"]
    var collectionView : UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSegementControlTableViewCollectionView()
        fetchUsersForRecomendation(){_ in}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUsersForRecomendation(){_ in
            
            self.peopleTableView.reloadData()
        }
    }
    
    func addSegementControlTableViewCollectionView(){
        let control = UISegmentedControl(items: segmentItems)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        view.addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice.current.userInterfaceIdiom != .pad{
            control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        else{
            control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50).isActive = true
        }
        control.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier:0.9).isActive = true
        control.heightAnchor.constraint(equalToConstant: 45).isActive = true
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchBar.topAnchor.constraint(equalTo: control.bottomAnchor,constant:10).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(peopleTableView)
        peopleTableView.translatesAutoresizingMaskIntoConstraints = false
        peopleTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant:10).isActive = true
        peopleTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        peopleTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        peopleTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        peopleTableView.register(CoustomUserTableViewCell.self, forCellReuseIdentifier: CoustomUserTableViewCell.identifier)
        peopleTableView.estimatedRowHeight = 100
        peopleTableView.rowHeight = UITableView.automaticDimension
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        peopleTableView.isHidden = true
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            collectionViewFlowLayout.itemSize = CGSize(width: 450, height: 300)
        }
        else{
            collectionViewFlowLayout.itemSize = CGSize(width: 350, height: 250)
        }
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 20
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView = UICollectionView(frame: view.frame,collectionViewLayout: collectionViewFlowLayout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(CoustomNewsCategoryCollectionViewCell.self, forCellWithReuseIdentifier: CoustomNewsCategoryCollectionViewCell.reusableIdentifier)
        view.addSubview(collectionView!)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.95).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant:10).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
           peopleTableView.isHidden = true
           collectionView?.isHidden = false
             // First segment tapped
          break
          case 1:
           peopleTableView.isHidden = false
           collectionView?.isHidden = true
             // Second segment tapped
          break
          default:
          break
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


extension SearchUsersAndNewsViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoustomNewsCategoryCollectionViewCell.reusableIdentifier, for: indexPath) as! CoustomNewsCategoryCollectionViewCell
        cell.newsCategory.setBackgroundImage(UIImage(named: "\(indexPath.row+1)"), for: .normal)
        cell.newsCategory.setTitle(newsCategory[indexPath.row], for: .normal)
        cell.newsCategory.addTarget(self, action:#selector(didtap(button: )), for: .touchUpInside)
        cell.newsCategory.tag = indexPath.row
        cell.nameOfTheCategory.text = newsCategory[indexPath.row]
        return cell
    }
    
    @objc func didtap(button:UIButton){
        print("tapped")
        let nextVC = NewsFeedViewController()
        nextVC.newsCategory = (button.titleLabel?.text)!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

