//
//  FeedPageViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class TrendingPageViewController: UIViewController {

    let tableView = UITableView()
    var arrayOfArticles = [Article]()
    var newsCategory : NewsCategory? = nil
    let refreshControl = UIRefreshControl()
    var isPaginating = false
    var keyword : String? = nil
    var country : Country? = nil
    let newsAPI = NewsAPINetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        addTableView()
        loadHeadLines(keyword: nil, country: .In, newsCategory: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func loadHeadLines(keyword:String?,country:Country?,newsCategory:NewsCategory?){
        self.newsCategory = newsCategory
        self.country = country
        self.keyword = keyword
        newsAPI.sessionToLoadHeadLines(keyword: keyword, country: country, newsCategory: newsCategory){ data,error in
            if error == nil && data?.articles != nil{
                self.arrayOfArticles = data!.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
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
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        newsAPI.sessionToLoadHeadLines(keyword: keyword, country: country, newsCategory: newsCategory){ data,error in
            if error == nil && data?.articles != nil{
                self.arrayOfArticles = data!.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
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


extension TrendingPageViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedPageTableViewCell.identifier) as! NewsFeedPageTableViewCell
        cell.loadNewscell(article: arrayOfArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailedNewsViewController()
        nextVC.article = arrayOfArticles[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height+100-scrollView.frame.height) && !isPaginating{
            isPaginating = true
            newsAPI.fetchMore(){ moreData,error in
                if error == nil && moreData?.articles != nil{
                    self.arrayOfArticles.append(contentsOf: moreData!.articles)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.isPaginating = false
                    }
                }
            }
        }
    }
    

}
