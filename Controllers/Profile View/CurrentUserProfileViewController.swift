//
//  ProfileViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 01/01/23.
//

import UIKit

class CurrentUserProfileViewController: UIViewController {

    public var email = String()
    fileprivate let tableView = UITableView()
    fileprivate let data = UILabel()
    fileprivate var scrollView = UIScrollView()
    fileprivate var verticalStack = UIStackView()
    fileprivate var curretAccount = currentUserAccountObject()
    fileprivate var articlesArray = [Article]()
    fileprivate let profilePicture = UIButton()
    fileprivate let descriptionLabel = UILabel()
    fileprivate let RecentActivityButton = UIButton()
    fileprivate let followingButton = UIButton()
    fileprivate let followersButton = UIButton()
    fileprivate let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    fileprivate let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
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
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        fetchCurrenUserProfileData(completionHandler: {_ in})
        fetchProfilePicture(url: currentUserAccountObject().profilePicture!){ imageData in
            DispatchQueue.main.async {
                self.profilePicture.setImage(UIImage(data: imageData), for: .normal)
                self.followingButton.setTitle("Following : \(currentUserAccountObject().followingList.count)", for: .normal)
                self.followersButton.setTitle("Followers : \(currentUserAccountObject().followersList.count)", for: .normal)
                self.descriptionLabel.text = currentUserAccountObject().profileDescription
            }
        }
        fetchCurrentUserRecentActivityArticlesArray(){ articles in
            self.articlesArray  = articles
            DispatchQueue.main.async {
                self.dismiss(animated: false,completion: nil)
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
        profilePicture.widthAnchor.constraint(equalToConstant: 110).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 110).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 85+10).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor,constant: 10+10).isActive = true
        profilePicture.layer.cornerRadius = 45
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
                self.profilePicture.setImage(UIImage(data: imageData), for: .normal)
            }
        }
        profilePicture.addTarget(self, action: #selector(viewProfileImage), for: .touchUpInside)
        
        let editProfilePicture = UIButton()
        editProfilePicture.setImage( UIImage(systemName: "plus.circle.fill"), for: .normal)
        editProfilePicture.imageView?.sizeToFit()
        verticalStack.addSubview(editProfilePicture)
        editProfilePicture.translatesAutoresizingMaskIntoConstraints = false
        editProfilePicture.widthAnchor.constraint(equalToConstant: 44).isActive = true
        editProfilePicture.heightAnchor.constraint(equalToConstant: 44).isActive = true
        editProfilePicture.centerXAnchor.constraint(equalTo: profilePicture.trailingAnchor,constant: -10).isActive = true
        editProfilePicture.centerYAnchor.constraint(equalTo: profilePicture.bottomAnchor,constant: -10).isActive = true
        editProfilePicture.addTarget(self, action: #selector(viewProfileImage), for: .touchUpInside)
        
    }
    
    fileprivate func addNameLabel(){
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 25)
        nameLabel.text = curretAccount.userName
        verticalStack.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor,constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor,constant: -20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    fileprivate func addDescriptionLabel(){
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
        editDescription.centerYAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: -5).isActive = true
        editDescription.addTarget(self, action: #selector(editAndUpdateDescription), for: .touchUpInside) // requiers edit
        
    }
    
    fileprivate func addFollowersFollowingAndRecentActivityBlock(){
        followersButton.backgroundColor = .black
        followersButton.setTitle("Followers : \(curretAccount.followersList.count)", for: .normal)
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
        followingButton.setTitle("Following : \(curretAccount.followingList.count)", for: .normal)
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
        nextVC.uiImage = profilePicture.currentImage!
        nextVC.isCurrentUser = true
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc func loadFollowersView(){
        let nextVC = FollowersFollowingViewController()
        nextVC.title = "Followers"
        nextVC.accountList = curretAccount.followersList
        nextVC.account = currentUserAccountObject()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func editAndUpdateDescription(){
        let nextVC = EditDescriptionViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func loadFollowingView(){
        let nextVC = FollowersFollowingViewController()
        nextVC.accountList = curretAccount.followingList
        nextVC.title = "Following"
        nextVC.account = currentUserAccountObject()
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


extension CurrentUserProfileViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
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
