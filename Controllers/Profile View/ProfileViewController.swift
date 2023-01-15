//
//  ProfileViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 11/01/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    public var nonCurrentUser = Account()
    fileprivate let tableView = UITableView()
    fileprivate let data = UILabel()
    fileprivate var scrollView = UIScrollView()
    fileprivate var verticalStack = UIStackView()
    fileprivate var curretAccount = currentUserAccountObject()
    fileprivate var articlesArray = [Article]()
    fileprivate let profilePicture = UIButton()
    fileprivate let descriptionLabel = UILabel()
    fileprivate let followingButton = UIButton()
    fileprivate let followersButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addAndConfigureScrollView()
        confgureVerticalStack()
        loadImageToStack()
        addNameLabel()
        addDescriptionLabel()
        addFollowersFollowingAndRecentActivityBlock()
        addTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
        
        fetchUserRecentActivity(email: nonCurrentUser.email){ articles in
            self.articlesArray = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.verticalStack.frame.height)
            }
        }
    }
    
    fileprivate func loadImageToStack(){
        let backroundImage = UIImageView(image: UIImage(named: "login Background"))
        verticalStack.addSubview(backroundImage)
        backroundImage.contentMode = .scaleToFill
        backroundImage.translatesAutoresizingMaskIntoConstraints = false
        backroundImage.widthAnchor.constraint(equalTo: verticalStack.widthAnchor).isActive = true
        backroundImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        backroundImage.topAnchor.constraint(equalTo: verticalStack.topAnchor).isActive = true
        backroundImage.centerXAnchor.constraint(equalTo: verticalStack.centerXAnchor).isActive = true

        let topMask = UILabel()
        verticalStack.addSubview(topMask)
        topMask.backgroundColor = .systemBackground
        topMask.translatesAutoresizingMaskIntoConstraints = false
        topMask.heightAnchor.constraint(equalToConstant: 150).isActive = true
        topMask.widthAnchor.constraint(equalTo: verticalStack.widthAnchor,multiplier: 1.01).isActive = true
        topMask.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor).isActive = true
        topMask.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor).isActive = true
        topMask.layer.cornerRadius = 85
        topMask.layer.maskedCorners = [.layerMinXMinYCorner]
        topMask.layer.masksToBounds = true
        
        
        verticalStack.addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.widthAnchor.constraint(equalToConstant: 110).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 110).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 85+10).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor,constant: 10+10).isActive = true
        profilePicture.layer.cornerRadius = 45
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.systemGray.cgColor
        profilePicture.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        guard let profilePictureURL = nonCurrentUser.profilePicture else{
            profilePicture.setImage(UIImage(imageLiteralResourceName: "profile picture 3"), for: .normal)
            return
        }
        fetchProfilePicture(url: profilePictureURL){ imageData in
            DispatchQueue.main.async {
                self.profilePicture.setImage(UIImage(data: imageData), for: .normal)
            }
        }
        profilePicture.addTarget(self, action: #selector(viewProfileImage), for: .touchUpInside)
        
    }
    
    fileprivate func addNameLabel(){
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 25)
        nameLabel.text = nonCurrentUser.userName
        verticalStack.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor,constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor,constant: -20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    fileprivate func addDescriptionLabel(){
        descriptionLabel.text = nonCurrentUser.profileDescription
        descriptionLabel.numberOfLines = 0
        verticalStack.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor,constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 0.85).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: verticalStack.centerXAnchor).isActive = true
        
    }
    
    fileprivate func addFollowersFollowingAndRecentActivityBlock(){
        followersButton.backgroundColor = .black
        followersButton.setTitle("Followers : \(nonCurrentUser.followersList.count)", for: .normal)
        followersButton.titleLabel?.textAlignment = .center
        followersButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        followersButton.setTitleColor(.white, for: .normal)
        verticalStack.addSubview(followersButton)
        followersButton.translatesAutoresizingMaskIntoConstraints = false
        followersButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        followersButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 30).isActive = true
        followersButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        followersButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        followersButton.addTarget(self, action: #selector(loadFollowersView), for: .touchUpInside)
        applyBorderForButton(button: followersButton)
        
        
        followingButton.backgroundColor = .black
        followingButton.setTitle("Following : \(nonCurrentUser.followingList.count)", for: .normal)
        followingButton.titleLabel?.textAlignment = .center
        followingButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        followingButton.setTitleColor(.white, for: .normal)
        verticalStack.addSubview(followingButton)
        followingButton.translatesAutoresizingMaskIntoConstraints = false
        followingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        followingButton.topAnchor.constraint(equalTo: followersButton.topAnchor).isActive = true
        followingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        followingButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        followingButton.addTarget(self, action: #selector(loadFollowingView), for: .touchUpInside)
        applyBorderForButton(button: followingButton)
    }
    
    fileprivate func applyBorderForButton(button:UIButton){
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 17
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        button.layer.masksToBounds = true
    }
    
    fileprivate func addAndConfigureScrollView(){
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    fileprivate func confgureVerticalStack(){
        scrollView.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        verticalStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        verticalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    }
    
    fileprivate func addTableView(){
        verticalStack.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: followersButton.bottomAnchor,constant: 30).isActive = true
        tableView.register(NewsFeedPageTableViewCell.self, forCellReuseIdentifier: NewsFeedPageTableViewCell.identifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func viewProfileImage(){
        let nextVC = FullProfilePictureViewController()
        fetchProfilePicture(url: nonCurrentUser.profilePicture!){ imageData in
            DispatchQueue.main.async {
                nextVC.uiImage = UIImage(data: imageData)!
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    @objc func loadFollowersView(){
        let nextVC = FollowersFollowingViewController()
        nextVC.title = "Followers"
        nextVC.account = nonCurrentUser
        nextVC.accountList = nonCurrentUser.followersList
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func loadFollowingView(){
        let nextVC = FollowersFollowingViewController()
        nextVC.title = "Following"
        nextVC.accountList = nonCurrentUser.followingList
        nextVC.account = nonCurrentUser
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func offlineTrigger(){
        DispatchQueue.main.async {
            self.dismiss(animated: true)
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

extension ProfileViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedPageTableViewCell.identifier) as! NewsFeedPageTableViewCell
        cell.loadNewscell(article: articlesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailedNewsViewController()
        nextVC.article = articlesArray[indexPath.row]
        let indexesToRedraw = [indexPath]
        tableView.reloadRows(at: indexesToRedraw, with: .fade)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
