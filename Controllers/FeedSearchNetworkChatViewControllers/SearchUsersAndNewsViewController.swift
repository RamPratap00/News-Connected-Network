//
//  SearchUsersAndNewsViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class SearchUsersAndNewsViewController: UIViewController, UITableViewDelegate {

    let tableView = UITableView()
    let currentUserAccount = currentUserAccountObject()
    var arrayOfAccounts = [Account]()
    let refreshControl = UIRefreshControl()
    var searchBar = UISearchBar()
    let segmentItems = ["News", "People"]
    let newsCategory = ["business","entertainment","general","health","science","sports","technology"]
    var collectionView : UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        addSegementControlTableViewCollectionView()
        fetchUsersForRecomendation(){accounts in self.arrayOfAccounts=accounts}
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        fetchCurrenUserProfileData( ){ _ in
            fetchUsersForRecomendation(){
                accounts in self.arrayOfAccounts=accounts
                self.tableView.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCurrenUserProfileData( ){ _ in
            fetchUsersForRecomendation(){ accounts in
                self.arrayOfAccounts=accounts
                self.tableView.reloadData()
            }
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
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchBar.topAnchor.constraint(equalTo: control.bottomAnchor,constant:10).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: control.leadingAnchor).isActive = true
        searchBar.showsCancelButton = false
        searchBar.placeholder = "  Discover News"
        
        let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "arrowshape.right"), for: .normal)
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: control.trailingAnchor).isActive = true
        searchButton.addTarget(self, action: #selector(newsSeacrhInitiate), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant:10).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.register(CoustomUserTableViewCell.self, forCellReuseIdentifier: CoustomUserTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            collectionViewFlowLayout.itemSize = CGSize(width: 450, height: 300)
        }
        else{
            collectionViewFlowLayout.itemSize = CGSize(width: 380, height: 250)
        }
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 20
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
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
    
    
    @objc func newsSeacrhInitiate(){
        let nextVC = NewsFeedViewController()
        let currentUser = currentUserAccountObject()
        if let keyword = searchBar.text{
            nextVC.keyword = keyword
            nextVC.language = currentUser.language
            nextVC.loadNews()
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
           tableView.isHidden = true
           collectionView?.isHidden = false
           searchBar.placeholder = "  Discover News"
             // First segment tapped
          break
          case 1:
           tableView.isHidden = false
           collectionView?.isHidden = true
           searchBar.placeholder = "  Discover People"
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
            return arrayOfAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: CoustomUserTableViewCell.identifier, for: indexPath) as! CoustomUserTableViewCell
            let account = arrayOfAccounts[indexPath.row]
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
        nextVC.email = arrayOfAccounts[indexPath.row].email
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    
    
}


extension SearchUsersAndNewsViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoustomNewsCategoryCollectionViewCell.reusableIdentifier, for: indexPath) as! CoustomNewsCategoryCollectionViewCell
        cell.newsCategory.setBackgroundImage(   UIImage(named: "\(indexPath.row+1)")! , for: .normal)
        cell.newsCategory.setTitle(newsCategory[indexPath.row], for: .normal)
        cell.newsCategory.addTarget(self, action:#selector(didtap(button: )), for: .touchUpInside)
        cell.newsCategory.tag = indexPath.row
        cell.nameOfTheCategory.text = newsCategory[indexPath.row]
        return cell
    }
    
    @objc func didtap(button:UIButton){
        let nextVC = NewsFeedViewController()
        let currentUser = currentUserAccountObject()
        nextVC.loadHeadLines(keyword: nil, country: nil, newsCategory: NewsCategory(rawValue: (button.titleLabel?.text)!), language: currentUser.language)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

