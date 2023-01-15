//
//  TNewsFeedPageTableViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import UIKit

class NewsFeedPageTableViewCell: UITableViewCell {

    static let identifier = "News cell"
    public var articleThumbNail = UIImageView()
    fileprivate var article = Article()
    fileprivate var newsTitle = UILabel()
    fileprivate var iconContainerView : UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 300, height: 150)
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        return containerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadNewscell(article:Article){
        self.article = article
        thumbnailHandle()
        articleThumbNail.image = UIImage(imageLiteralResourceName: "default thubnail")
    articleThumbNail.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(articleThumbNail)
        articleThumbNail.widthAnchor.constraint(equalTo:contentView.widthAnchor ,multiplier: 0.9  ).isActive = true
        articleThumbNail.heightAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.7).isActive = true
    articleThumbNail.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    articleThumbNail.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true
        articleThumbNail.frame = contentView.bounds
        articleThumbNail.layer.cornerRadius = 30
        articleThumbNail.layer.borderWidth = 5
        articleThumbNail.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        articleThumbNail.layer.masksToBounds = true
        
    
    newsTitle.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(newsTitle)
    newsTitle.text = article.title
    newsTitle.widthAnchor.constraint(equalToConstant: 300).isActive = true
    newsTitle.leadingAnchor.constraint(equalTo: articleThumbNail.leadingAnchor).isActive = true
    newsTitle.topAnchor.constraint(equalTo: articleThumbNail.bottomAnchor, constant: 10).isActive = true
    newsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
    newsTitle.numberOfLines = 0
        
        setupLongPressGesture()
        
    }
    
    fileprivate func setupLongPressGesture(){
        contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    fileprivate func thumbnailHandle(){
        if hasNetworkConnection(){
            if article.urlToImage != "" && article.urlToImage != nil{
                
                if URL(string: article.urlToImage!) != nil{
                    fetchNewsThumbNail(url: URL(string: article.urlToImage!)!){ currentArticleThumbNail,error in
                        if currentArticleThumbNail == nil || error != nil{
                            DispatchQueue.main.async {
                                self.articleThumbNail.image = UIImage(imageLiteralResourceName: "default thubnail")
                            }
                            return
                        }
                        else{
                            DispatchQueue.main.async {
                                if UIImage(data: currentArticleThumbNail!) != nil{
                                    self.articleThumbNail.image = convertToGrayScale(image: UIImage(data: currentArticleThumbNail!)!)
                                }
                                else{
                                    self.articleThumbNail.image = UIImage(imageLiteralResourceName: "default thubnail")
                                }
                            }
                        }
                    }
                }
            }
            else{
                articleThumbNail.image = convertToGrayScale(image: UIImage(imageLiteralResourceName: "login Background" ))
            }
        }
    }
    
    @objc func handleLongPress(gesture:UILongPressGestureRecognizer){
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = article.description
        iconContainerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: iconContainerView.widthAnchor, multiplier: 0.9).isActive = true
        label.heightAnchor.constraint(equalTo: iconContainerView.heightAnchor, multiplier: 0.95).isActive = true
        label.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor).isActive = true
        
        
        if gesture.state == .began{
            let pressedLocation = gesture.location(in: self.contentView)
            iconContainerView.center = pressedLocation
            iconContainerView.center.y = iconContainerView.frame.maxY
            contentView.addSubview(iconContainerView )
            
            iconContainerView.alpha = 0
            
            UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 1 , initialSpringVelocity: 1 , animations: {
                self.iconContainerView.alpha = 1
                self.iconContainerView.center = pressedLocation
            })
        }
        else if gesture.state == .ended{
            iconContainerView.removeFromSuperview()
        }
        
    }
    
}


func createSpinnerFooter(view:UIView) -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
     let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    return footerView
}
