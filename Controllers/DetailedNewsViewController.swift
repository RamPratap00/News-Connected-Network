//
//  DetailedNewsViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 04/01/23.
//

import UIKit

class DetailedNewsViewController: UIViewController {

    var article = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addReactionButton()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    func addReactionButton(){
        let positiveButton = UIButton()
        positiveButton.setTitle("Positive", for: .normal)
        positiveButton.setTitleColor(.green, for: .normal)
        view.addSubview(positiveButton)
        positiveButton.translatesAutoresizingMaskIntoConstraints = false
        positiveButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        positiveButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        positiveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        positiveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        positiveButton.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStampAndPositiveReaction), for: .touchUpInside)
        
        let negativeButton = UIButton()
        negativeButton.setTitle("Negative", for: .normal)
        negativeButton.setTitleColor(.red, for: .normal)
        view.addSubview(negativeButton)
        negativeButton.translatesAutoresizingMaskIntoConstraints = false
        negativeButton.widthAnchor.constraint(equalToConstant: 80 ).isActive = true
        negativeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        negativeButton.leadingAnchor.constraint(equalTo: positiveButton.trailingAnchor).isActive = true
        negativeButton.centerYAnchor.constraint(equalTo: positiveButton.centerYAnchor).isActive = true
        negativeButton.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStampAndNegativeReaction), for: .touchUpInside)
        
        
        let neutralButton = UIButton()
        neutralButton.setTitle("Neutral", for: .normal)
        neutralButton.setTitleColor(.gray, for: .normal)
        view.addSubview(neutralButton)
        neutralButton.translatesAutoresizingMaskIntoConstraints = false
        neutralButton.trailingAnchor.constraint(equalTo: positiveButton.leadingAnchor).isActive = true
        neutralButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        neutralButton.centerYAnchor.constraint(equalTo: positiveButton.centerYAnchor).isActive = true
        neutralButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        neutralButton.addTarget(self, action: #selector(pushToCurrentUsersRecentActivityStackWithTimeStampAndNeutralReaction), for: .touchUpInside)
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStampAndPositiveReaction(){
        updateFireBaseRecentActivityStack(article: article,reaction: "positive")
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStampAndNegativeReaction(){
        updateFireBaseRecentActivityStack(article: article,reaction: "negative")
    }
    
    @objc func pushToCurrentUsersRecentActivityStackWithTimeStampAndNeutralReaction(){
        updateFireBaseRecentActivityStack(article: article,reaction: "neutral")
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


