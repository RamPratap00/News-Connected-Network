//
//  FeedPageViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class TrendingPageViewController: UIViewController {

    let tableView = UITableView()
    var arrayOfArticles = [ArticlesWithTimeStampAndReactions]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTableView()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        fetchTrendingArticlesOnGlobalUsersNetwork(){ articleWithReactionDictionary in
            self.arrayOfArticles = articleWithReactionDictionary
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        fetchTrendingArticlesOnGlobalUsersNetwork(){ articleWithReactionDictionary in
            self.arrayOfArticles = articleWithReactionDictionary
            self.tableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func addTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.register(NewsFeedPageTableViewCell.self, forCellReuseIdentifier: NewsFeedPageTableViewCell.identifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
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


extension TrendingPageViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedPageTableViewCell.identifier) as! NewsFeedPageTableViewCell
        let reactionArray = [arrayOfArticles[indexPath.row].reaction.negativeCount,
                             arrayOfArticles[indexPath.row].reaction.positiveCount,
                             arrayOfArticles[indexPath.row].reaction.neutralCount]
        let maxIndex = reactionArray.firstIndex(of: reactionArray.max()!)
        cell.loadNewscell(article: arrayOfArticles[indexPath.row].article)
        if maxIndex == 0{
            cell.articleThumbNail.layer.borderColor = .init(red: 33, green: 0, blue: 0, alpha: 0.4)
        }
        else if maxIndex == 1{
            cell.articleThumbNail.layer.borderColor = .init(red: 0, green: 33, blue: 0, alpha: 0.4)
        }
        else{
            cell.articleThumbNail.layer.borderColor = .init(red: 107, green: 114, blue: 142, alpha: 0.4)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailedNewsViewController()
        nextVC.article = arrayOfArticles[indexPath.row].article
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
