//
//  AllNewsFeedViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 14/01/23.
//

import UIKit

class AllNewsFeedViewController: UIViewController {

    
    let tableView = UITableView()
    var arrayOfArticles = [Article]()
    var keyword = String()
    var language = currentUserAccountObject().language
    var isPaginating = false
    var isDataLoaded = false
    let newsAPI = NewsAPINetworkManager()
    let alert = UIAlertController(title: nil, message: "Loading articles...", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTableView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arrayOfArticles = []
        relodTableView()
        
        newsAPI.headLinesActive = true
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        loadNews(){ _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                self.relodTableView()
            }
        }
    }
    
    func addWarningLabel(){
        let warningLabel = UIImageView(image: UIImage(imageLiteralResourceName: "empty news paper"))
        view.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func loadNews(completionHandler: @escaping (Bool)->()){
        
        newsAPI.session(keyword: keyword, searchIn: .content, language: language, sortBy: .relevancy){ data,error in
            if error == nil && data?.articles != nil{
                self.arrayOfArticles = data!.articles
                if self.arrayOfArticles.count == 0{
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                        self.addWarningLabel()
                    }
                    completionHandler(false)
                }
                completionHandler(true)
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



extension AllNewsFeedViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
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
            self.tableView.tableFooterView = createSpinnerFooter(view: view)
            if position > (tableView.contentSize.height+200-scrollView.frame.height) && !isPaginating{
                isPaginating = true
                newsAPI.fetchMore(){ moreData,error in
                    if error == nil && moreData?.articles != nil{
                        self.arrayOfArticles.append(contentsOf: moreData!.articles)
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
