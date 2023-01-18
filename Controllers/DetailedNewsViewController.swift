//
//  DetailedNewsViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 04/01/23.
//

import UIKit
import SafariServices

class DetailedNewsViewController: UIViewController {

    public var article = Article()
    fileprivate let positiveButton = UIButton()
    fileprivate let negativeButton = UIButton()
    fileprivate let neutralButton = UIButton()
    public var isNavigationControllerNil = false
    fileprivate let thumbNail = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addReactionButton()
        addDetailView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "share", style: .plain, target: self, action: #selector(shareArticle))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNavigationControllerNil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(fallBack))
        }
    }
    
    fileprivate func addReactionButton() {
        positiveButton.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill.badge.checkmark"), for: .normal)
        positiveButton.tintColor = .gray
        view.addSubview(positiveButton)
        positiveButton.translatesAutoresizingMaskIntoConstraints = false
        positiveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        positiveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        positiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        positiveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20).isActive = true
        positiveButton.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStampAndPositiveReaction), for: .touchUpInside)
        
        negativeButton.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill.badge.xmark"), for: .normal)
        negativeButton.tintColor = .gray
        view.addSubview(negativeButton)
        negativeButton.translatesAutoresizingMaskIntoConstraints = false
        negativeButton.widthAnchor.constraint(equalToConstant: 50 ).isActive = true
        negativeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        negativeButton.leadingAnchor.constraint(equalTo: positiveButton.trailingAnchor,constant: 15).isActive = true
        negativeButton.centerYAnchor.constraint(equalTo: positiveButton.centerYAnchor).isActive = true
        negativeButton.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStampAndNegativeReaction), for: .touchUpInside)
        
        
        neutralButton.setBackgroundImage(UIImage(systemName: "person.crop.circle.badge.exclamationmark.fill"), for: .normal)
        neutralButton.tintColor = .gray
        view.addSubview(neutralButton)
        neutralButton.translatesAutoresizingMaskIntoConstraints = false
        neutralButton.trailingAnchor.constraint(equalTo: positiveButton.leadingAnchor,constant: -15).isActive = true
        neutralButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        neutralButton.centerYAnchor.constraint(equalTo: positiveButton.centerYAnchor).isActive = true
        neutralButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        neutralButton.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStampAndNeutralReaction), for: .touchUpInside)
    }
    
    fileprivate func addDetailView() {
        view.addSubview(thumbNail)
        thumbNail.image = UIImage(imageLiteralResourceName: "default thubnail")
        thumbNail.translatesAutoresizingMaskIntoConstraints = false
        thumbNail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad{
            thumbNail.widthAnchor.constraint(equalToConstant: 450).isActive = true
            thumbNail.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
        else{
            thumbNail.widthAnchor.constraint(equalToConstant: 380).isActive = true
            thumbNail.heightAnchor.constraint(equalToConstant: 250).isActive = true
        }
        thumbNail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 25).isActive = true
        thumbNail.layer.cornerRadius = 30
        thumbNail.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        thumbNail.layer.masksToBounds = true
        
        if article.urlToImage == nil{
            thumbNail.image = UIImage(imageLiteralResourceName: "login Background")
            loadTitleDescriptionAndLinkToFullArticleUIViews()
            return
        }
        
        if URL(string: article.urlToImage!) == nil{
            thumbNail.image = UIImage(imageLiteralResourceName: "login Background")
            loadTitleDescriptionAndLinkToFullArticleUIViews()
            return
        }
        
        
        fetchNewsImage(url: URL(string: article.urlToImage!)! ){ imageData,error in
            if error == nil && imageData != nil{
                DispatchQueue.main.async {
                    self.thumbNail.image = UIImage(data: imageData!)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.thumbNail.image = UIImage(imageLiteralResourceName: "default thubnail")
                }
            }
        }
        loadTitleDescriptionAndLinkToFullArticleUIViews()
}
    
    fileprivate func loadTitleDescriptionAndLinkToFullArticleUIViews(){
        let title = UILabel()
        title.text = article.title
        title.font = .boldSystemFont(ofSize: 20)
        title.numberOfLines = 0
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: thumbNail.bottomAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 150).isActive = true
       
        let description = UILabel()
        description.text = article.description
        description.font = .systemFont(ofSize: 20)
        view.addSubview(description)
        description.numberOfLines = 0
        description.translatesAutoresizingMaskIntoConstraints = false
        description.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        description.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 5).isActive = true
        description.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        description.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let linkToFullArticle = UIButton()
        linkToFullArticle.setTitle("View Full Article", for: .normal)
        linkToFullArticle.setTitleColor(.gray, for: .normal)
        view.addSubview(linkToFullArticle)
        linkToFullArticle.translatesAutoresizingMaskIntoConstraints = false
        linkToFullArticle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        linkToFullArticle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        linkToFullArticle.bottomAnchor.constraint(equalTo: positiveButton.topAnchor).isActive = true
        linkToFullArticle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        linkToFullArticle.addTarget(self, action: #selector(openSafari), for: .touchUpInside)
        linkToFullArticle.titleLabel?.numberOfLines = 0

        description.bottomAnchor.constraint(equalTo: linkToFullArticle.topAnchor).isActive = true
        
    }
    
    @objc func openSafari() {
        let url = URL(string: article.url!)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true)
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStampAndPositiveReaction(){
        positiveButton.tintColor = .green
        negativeButton.tintColor = .gray
        neutralButton.tintColor = .gray
        updateFireBaseRecentActivityStack(article: article,reaction: "positive")
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStampAndNegativeReaction(){
        positiveButton.tintColor = .gray
        negativeButton.tintColor = .red
        neutralButton.tintColor = .gray
        updateFireBaseRecentActivityStack(article: article,reaction: "negative")
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStampAndNeutralReaction(){
        positiveButton.tintColor = .gray
        negativeButton.tintColor = .gray
        neutralButton.tintColor = .yellow
        updateFireBaseRecentActivityStack(article: article,reaction: "neutral")
    }

    @objc func shareArticle(){
        let nextVC = ChattingViewController()
        nextVC.isSharing = true
        nextVC.articleUrl = article.url!
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func fallBack(){
        self.dismiss(animated: true)
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
