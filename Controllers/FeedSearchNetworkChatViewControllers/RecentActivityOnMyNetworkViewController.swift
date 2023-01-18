//
//  RecentActivityOnMyNetworkViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import UIKit

class RecentActivityOnMyNetworkViewController: UIViewController{
    

    fileprivate let tableView = UITableView()
    fileprivate var isViewOnMyNetwork = true
    fileprivate let segmentItems = ["My Network", "Global Network"]
    fileprivate var arrayOfArticles = [ArticleWithTimeStampAndReactions]()
    fileprivate let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTableView()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        fetchTrendingArticlesOnCurrentlyLoggedInUserNetwork(){ articleWithReactionDictionary in
            self.arrayOfArticles = articleWithReactionDictionary
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
    }
    
    fileprivate func addTableView(){
        
        let control = UISegmentedControl(items: segmentItems)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        view.addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice.current.userInterfaceIdiom != .pad{
            control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        else{
            control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 60).isActive = true
        }
        control.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier:0.9).isActive = true
        control.heightAnchor.constraint(equalToConstant: 45).isActive = true
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: control.bottomAnchor,constant: 10).isActive = true
        tableView.register(NewsFeedPageTableViewCell.self, forCellReuseIdentifier: NewsFeedPageTableViewCell.identifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func offlineTrigger(){
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        if isViewOnMyNetwork{
            fetchTrendingArticlesOnCurrentlyLoggedInUserNetwork(){ articleWithReactionDictionary in
                self.arrayOfArticles = articleWithReactionDictionary
                self.tableView.reloadData()
            }
        }
        else{
            fetchTrendingArticlesOnGlobalUsersNetwork(){ articleWithReactionDictionary in
                self.arrayOfArticles = articleWithReactionDictionary
                self.tableView.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
           fetchTrendingArticlesOnCurrentlyLoggedInUserNetwork(){ articleWithReactionDictionary in
               self.arrayOfArticles = articleWithReactionDictionary
               self.tableView.reloadData()
           }
           isViewOnMyNetwork = true
          break
          case 1:
           fetchTrendingArticlesOnGlobalUsersNetwork(){ articleWithReactionDictionary in
               self.arrayOfArticles = articleWithReactionDictionary
               self.tableView.reloadData()
           }
           isViewOnMyNetwork = false
          break
          default:
          break
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

extension RecentActivityOnMyNetworkViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedPageTableViewCell.identifier) as! NewsFeedPageTableViewCell
        let reactionArray = [arrayOfArticles[indexPath.row].reaction.negativeCount,
                             arrayOfArticles[indexPath.row].reaction.positiveCount,
                             arrayOfArticles[indexPath.row].reaction.neutralCount]
        let maxIndex = reactionArray.firstIndex(of: reactionArray.max()!)
        cell.parent = self
        cell.loadNewscell(article: arrayOfArticles[indexPath.row].article)
        if maxIndex == 0{
            cell.articleThumbNail.layer.borderColor = .init(red: 33, green: 0, blue: 0, alpha: 0.4)
        }
        else if maxIndex == 1{
            cell.articleThumbNail.layer.borderColor = .init(red: 0, green: 33, blue: 0, alpha: 0.4)
        }
        else{
            cell.articleThumbNail.layer.borderColor = .init(red: 255, green: 255, blue: 0, alpha: 0.4)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailedNewsViewController()
        nextVC.article = arrayOfArticles[indexPath.row].article
        let indexesToRedraw = [indexPath]
        tableView.reloadRows(at: indexesToRedraw, with: .fade)
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
