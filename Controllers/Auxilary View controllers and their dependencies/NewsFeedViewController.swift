//
//  NewsFeedViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import UIKit

class NewsFeedViewController: UIViewController {

    fileprivate let tableView = UITableView()
    fileprivate var articlesArray = [Article]()
    fileprivate var isPaginating = false
    fileprivate let newsAPINetworkManager = NewsAPINetworkManager()
    fileprivate var isFirstVisit = true
    fileprivate let alert = UIAlertController(title: nil, message: "Loading articles...", preferredStyle: .alert)
    fileprivate let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    public var newsCategory : NewsCategory? = nil
    public var keyword : String? = nil
    public var language : String? = currentLoggedInUserAccount().language
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTableView()
        newsAPINetworkManager.headLinesActive = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstVisit{
            articlesArray = []
            relodTableView()
            
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            loadHeadLines(keyword: keyword, newsCategory: newsCategory, language: language){ _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.isFirstVisit = false
                }
            }
        }
        
    }
    
    fileprivate func addWarningLabel(){
        let warningLabel = UIImageView(image: UIImage(imageLiteralResourceName: "empty news paper"))
        view.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func loadHeadLines(keyword:String?,newsCategory:NewsCategory?,language:String?,completionHandler: @escaping (Bool)->()){
        
        newsAPINetworkManager.sessionToLoadHeadLines(keyword: keyword, newsCategory: newsCategory, language: language){ data,error in
            
            if error == nil && data?.articles != nil{
                self.articlesArray = data!.articles
                if self.articlesArray.count == 0{
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                        self.addWarningLabel()
                    }
                    completionHandler(false)
                }
                completionHandler(true)
                self.relodTableView()
            }
            else{
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.addWarningLabel()
                }
                completionHandler(false)
            }
        }
    }
    
    fileprivate func relodTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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


extension NewsFeedViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedPageTableViewCell.identifier) as! NewsFeedPageTableViewCell
        cell.loadNewscell(article: articlesArray[indexPath.row])
        cell.parent = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailedNewsViewController()
        nextVC.article = articlesArray[indexPath.row]
        let indexesToRedraw = [indexPath]
        tableView.reloadRows(at: indexesToRedraw, with: .fade)
        navigationController?.pushViewController(nextVC, animated: true)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let position = scrollView.contentOffset.y
            if position > (tableView.contentSize.height+100-scrollView.frame.height) && !isPaginating{
                isPaginating = true
                newsAPINetworkManager.fetchMore(){ moreData,error in
                    if error == nil && moreData?.articles != nil{
                        self.articlesArray.append(contentsOf: moreData!.articles)
                        DispatchQueue.main.async {
                            self.relodTableView()
                            self.tableView.tableFooterView = nil
                            self.isPaginating = false
                        }
                    }
                }
            }
    }
    
}



