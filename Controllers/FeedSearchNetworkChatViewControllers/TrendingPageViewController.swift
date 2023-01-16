//
//  FeedPageViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class TrendingPageViewController: UIViewController {

    fileprivate let tableView = UITableView()
    fileprivate var arrayOfArticles = [Article]()
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var isPaginating = false
    fileprivate let newsAPI = NewsAPINetworkManager()
    fileprivate let alert = UIAlertController(title: nil, message: "Loading articles...", preferredStyle: .alert)
    fileprivate let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addTableView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        loadHeadLinesForTrendingPage(keyword: nil, newsCategory: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
    }
    
    fileprivate func loadHeadLinesForTrendingPage(keyword:String?,newsCategory:NewsCategory?){
        if !hasNetworkConnection(){
            addWarningLabel()
            self.dismiss(animated: false, completion: nil)
            return
        }
        fetchCurrenUserProfileData(completionHandler: { _ in})
        let currentUser = currentUserAccountObject()
        newsAPI.sessionToLoadHeadLines(keyword: keyword, newsCategory: newsCategory, language: currentUser.language){ data,error in
            if error != nil || data == nil{
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                    self.addWarningLabel()
                }
    
            }
            if error == nil && data?.articles != nil{
                self.arrayOfArticles = data!.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.dismiss(animated: false, completion: nil)
                    if self.arrayOfArticles.count == 0{
                        self.addWarningLabel()
                    }
                }
            }
        }
    }
    
    fileprivate func addWarningLabel(){
        let warningLabel = UIImageView(image: UIImage(imageLiteralResourceName: "empty news paper"))
        view.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: 250).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func addTableView(){
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
    
    @objc func offlineTrigger(){
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        let currentUser = currentUserAccountObject()
        newsAPI.sessionToLoadHeadLines(keyword: nil, newsCategory: nil, language: currentUser.language){ data,error in
            if error == nil && data == nil{
                print("error preparing url")
            }
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
        cell.parent = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailedNewsViewController()
        nextVC.article = arrayOfArticles[indexPath.row]
        let indexesToRedraw = [indexPath]
        tableView.reloadRows(at: indexesToRedraw, with: .fade)
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
