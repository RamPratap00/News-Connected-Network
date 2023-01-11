//
//  ProfileViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 01/01/23.
//

import UIKit

class CurrentUserProfileViewController: UIViewController {

    var email = String()
    let data = UILabel()
    var scrollView = UIScrollView()
    var verticalStack = UIStackView()
    var curretAccount = currentUserAccountObject()
    var articlesArray = [Article]()
    let profilePicture = UIButton()
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addAndConfigureScrollView()
        confgureVerticalStack()
        loadImageToStack()
        addNameLabel()
        addDescriptionLabel()
        addFollowersFollowingAndRecentActivityBlock()
        //scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height*1.1)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCurrenUserProfileData(completionHandler: {_ in})
        fetchProfilePicture(url: currentUserAccountObject().profilePicture!){ imageData in
            DispatchQueue.main.async {
                self.profilePicture.setImage(UIImage(data: imageData), for: .normal)
            }
        }
    }
    
    func loadImageToStack(){
        let backroundImage = UIImageView(image: UIImage(named: "login Background"))
        verticalStack.addSubview(backroundImage)
        backroundImage.contentMode = .scaleToFill
        backroundImage.translatesAutoresizingMaskIntoConstraints = false
        backroundImage.widthAnchor.constraint(equalTo: verticalStack.widthAnchor).isActive = true
        backroundImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        backroundImage.topAnchor.constraint(equalTo: verticalStack.topAnchor).isActive = true
        backroundImage.centerXAnchor.constraint(equalTo: verticalStack.centerXAnchor).isActive = true
        
        let signUpLabel = UILabel()
        verticalStack.addSubview(signUpLabel)
        signUpLabel.backgroundColor = .systemBackground
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        signUpLabel.widthAnchor.constraint(equalTo: verticalStack.widthAnchor,multiplier: 1.01).isActive = true
        signUpLabel.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor).isActive = true
        signUpLabel.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor).isActive = true
        signUpLabel.layer.cornerRadius = 85
        signUpLabel.layer.maskedCorners = [.layerMinXMinYCorner]
        signUpLabel.layer.masksToBounds = true
        
        verticalStack.addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 130).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 85+10).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor,constant: 10+10).isActive = true
        profilePicture.layer.cornerRadius = 65
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.systemGray.cgColor
        profilePicture.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        guard let profilePictureURL = curretAccount.profilePicture else{
            //profilePicture.image = UIImage(imageLiteralResourceName: "profile picture 3")
            profilePicture.setImage(UIImage(imageLiteralResourceName: "profile picture 3"), for: .normal)
            return
        }
        fetchProfilePicture(url: profilePictureURL){ imageData in
            DispatchQueue.main.async {
               // self.profilePicture.image = UIImage(data: imageData)
                self.profilePicture.setImage(UIImage(data: imageData), for: .normal)
            }
        }
        profilePicture.addTarget(self, action: #selector(viewProfileImage), for: .touchUpInside)
        
    }
    
    func addNameLabel(){
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = .boldSystemFont(ofSize: 30)
        nameLabel.text = curretAccount.userName
        verticalStack.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor,constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor,constant: -20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func addDescriptionLabel(){
        descriptionLabel.text = curretAccount.profileDescription
        descriptionLabel.numberOfLines = 0
        verticalStack.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor,constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 0.85).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: verticalStack.centerXAnchor).isActive = true
        
        let editDescription = UIButton()
        verticalStack.addSubview(editDescription)
        editDescription.setImage(UIImage(systemName: "pencil"), for: .normal)
        editDescription.translatesAutoresizingMaskIntoConstraints = false
        editDescription.widthAnchor.constraint(equalToConstant: 50).isActive = true
        editDescription.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editDescription.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        editDescription.topAnchor.constraint(equalTo: descriptionLabel.topAnchor).isActive = true
        editDescription.addTarget(self, action: #selector(viewProfileImage), for: .touchUpInside) // requiers edit
        
    }
    
    func addFollowersFollowingAndRecentActivityBlock(){
        let followersButton = UIButton()
        followersButton.backgroundColor = .black
        followersButton.setTitle("Followers : \(curretAccount.followersList.count)", for: .normal)
        followersButton.titleLabel?.textAlignment = .center
        followersButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        followersButton.setTitleColor(.white, for: .normal)
        verticalStack.addSubview(followersButton)
        followersButton.translatesAutoresizingMaskIntoConstraints = false
        followersButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        followersButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 30).isActive = true
        followersButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        followersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followersButton.addTarget(self, action: #selector(loadFollowersView), for: .touchUpInside)
        applyBorderForButton(button: followersButton)
        
        let followingButton = UIButton()
        followingButton.backgroundColor = .black
        followingButton.setTitle("Following : \(curretAccount.followingList.count)", for: .normal)
        followingButton.titleLabel?.textAlignment = .center
        followingButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        followingButton.setTitleColor(.white, for: .normal)
        verticalStack.addSubview(followingButton)
        followingButton.translatesAutoresizingMaskIntoConstraints = false
        followingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        followingButton.topAnchor.constraint(equalTo: followersButton.bottomAnchor,constant: 30).isActive = true
        followingButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        followingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followingButton.addTarget(self, action: #selector(loadFollowingView), for: .touchUpInside)
        applyBorderForButton(button: followingButton)
        
        let RecentActivityButton = UIButton()
        RecentActivityButton.backgroundColor = .black
        RecentActivityButton.titleLabel?.textAlignment = .center
        RecentActivityButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        RecentActivityButton.setTitleColor(.white, for: .normal)
        verticalStack.addSubview(RecentActivityButton)
        RecentActivityButton.translatesAutoresizingMaskIntoConstraints = false
        RecentActivityButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        RecentActivityButton.topAnchor.constraint(equalTo: followingButton.bottomAnchor,constant: 30).isActive = true
        RecentActivityButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        RecentActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RecentActivityButton.addTarget(self, action: #selector(recentActivityView), for: .touchUpInside)
        applyBorderForButton(button: RecentActivityButton)
        
        fetchCurrentUserRecentActivity(){ articles in
            self.articlesArray  = articles
            DispatchQueue.main.async {
                RecentActivityButton.setTitle("Recent activity : \(articles.count)", for: .normal)
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.verticalStack.frame.height)
            }
        }

    }
    
    func applyBorderForButton(button:UIButton){
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 17
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        button.layer.masksToBounds = true
    }
    
    func addAndConfigureScrollView(){
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func confgureVerticalStack(){
        scrollView.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        verticalStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        verticalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    }
    
    @objc func viewProfileImage(){
        let nextVC = FullProfilePictureViewController()
        nextVC.uiImage = profilePicture.currentImage!
        nextVC.isCurrentUser = true
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc func loadFollowersView(){
        let nextVC = FollowersFollowingViewController()
        nextVC.title = "Followers"
        nextVC.accountList = curretAccount.followingList
        nextVC.account = currentUserAccountObject()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func recentActivityView(){
        let nextVC = NewsFeedViewController()
        nextVC.isRegularFeed = false
        nextVC.arrayOfArticles = articlesArray
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func loadFollowingView(){
        let nextVC = FollowersFollowingViewController()
        nextVC.accountList = curretAccount.followersList
        nextVC.title = "Following"
        nextVC.account = currentUserAccountObject()
        navigationController?.pushViewController(nextVC, animated: true)
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
