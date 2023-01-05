//
//  TNewsFeedPageTableViewCell.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import UIKit

class NewsFeedPageTableViewCell: UITableViewCell {

    static let identifier = "News cell"
    var articleThumbNail = UIImageView()
    var articleThumbNailUrl = String()
    var article = Article()
    var newsTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
    }
    
    func loadNewscell(article:Article){
        self.article = article
        fetchNewsThumbNail(url: URL(string: article.urlToImage!)!){ currentArticleThumbNail in
            DispatchQueue.main.async {
                self.articleThumbNail.image = convertToGrayScale(image: UIImage(data: currentArticleThumbNail)!)
            }
        }
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
