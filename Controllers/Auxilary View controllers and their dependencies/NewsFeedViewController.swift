//
//  NewsFeedViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import UIKit

class NewsFeedViewController: UIViewController {

    let tableView = UITableView()
    var arrayOfArticles = [Article]()
    var keyword = String()
    var language = String()
    var isPaginating = false
    var isDataLoaded = false
    let newsAPI = NewsAPINetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadNews(completionHandler: @escaping (Bool)->()){
        newsAPI.session(keyword: keyword, searchIn: .content, language: language, sortBy: .relevancy){ data,error in
            if error == nil && data?.articles != nil{
                self.arrayOfArticles = data!.articles
                completionHandler(true)
            }
            else{
                completionHandler(false)
            }
        }
    }
    func loadHeadLines(keyword:String?,country:Country?,newsCategory:NewsCategory?,language:String?,completionHandler: @escaping (Bool)->()){
        newsAPI.sessionToLoadHeadLines(keyword: keyword, country: country, newsCategory: newsCategory, language: language){ data,error in
            if error == nil && data?.articles != nil{
                self.arrayOfArticles = data!.articles
                completionHandler(true)
            }
            else{
                completionHandler(false)
            }
        }
    }
    
    func relodTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
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


extension NewsFeedViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
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



