//
//  FetchDataFromFireBase.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import Foundation
import Firebase
import UIKit
import FirebaseFirestore


func fetchCurrenUserProfileData(completionHandler: @escaping (Bool)->()){
    let db = Firestore.firestore()
    let email = UserDefaults.standard.value(forKey: "EMAIL") as! String
    ENCDEC.encryptMessage(message: email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            db.collection("IndividualUsersData")
                .document(encryptedDataBaseName)
                .getDocument { (document, error) in
                    // Check for error
                    if error == nil {
                        
                        // Check that this document exists
                        if document != nil && document!.exists {
                            
                            let documentData = document!.data()
                            // return using completion handler
                            UserDefaults.standard.set(documentData, forKey: "USERMETADATA")
                            fetchCurrentUserProfilePicture(){_ in completionHandler(true)}
                        }
                        
                    }
                    
                }
        }
    }
}

func fetchUserProfileData(email:String,completionHandler: @escaping (Account)->()){
    let db = Firestore.firestore()
    let account = Account()
    ENCDEC.encryptMessage(message: email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            db.collection("IndividualUsersData")
                .document(encryptedDataBaseName)
                .getDocument { (document, error) in
                    // Check for error
                    if error == nil {
                        
                        // Check that this document exists
                        if document != nil && document!.exists {
                            
                            let documentData = document!.data()
                            // return using completion handler
                            let followingList = documentData?["FOLLOWING_LIST"] as! Array<String>
                            let followersList = documentData?["FOLLOWERS_LIST"] as! Array<String>
                            account.userName = documentData?["USERNAME"] as! String
                            account.profileDescription = documentData?["PROFILE_DESCRIPTION"] as! String
                            account.profilePicture = URL(string: documentData?["URL_TO_PROFILE_PICTURE"] as! String)!
                            account.followersList = followersList
                            account.followingList = followingList
                            account.email = documentData?["EMAIL"] as! String
                            completionHandler(account)
                        }
                        
                    }
                    
                }
        }
    }
}

func fetchCurrentUserProfilePicture(completionHandler:@escaping(Bool)->()){
    let userData = UserDefaults.standard.value(forKey: "USERMETADATA") as! [String:Any]?
    let url = userData!["URL_TO_PROFILE_PICTURE"] as! String
    DispatchQueue.global(qos: .userInitiated).async {
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!){ data,response,error in
            if error == nil{
                UserDefaults.standard.set(data, forKey: "PROFILEPICTURE")
                completionHandler(true)
            }
        }
        dataTask.resume()
    }
}

func fetchUserProfilePicture(url:URL,completionHandler:@escaping(Data)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        let dataTask = URLSession.shared.dataTask(with:url){ data,response,error in
            if error == nil{
                completionHandler(data!)
            }
        }
        dataTask.resume()
    }
}

func fetchUsersForRecomendation(completionHandler:@escaping (Bool)->()){
    DispatchQueue.global().async{
        ArrayOfAccountsAndNews.recomendedAccounts = []
        let db = Firestore.firestore()
        db.collection("IndividualUsersData")
            .limit(to:30)
            .getDocuments { (snapshot, error) in
                ArrayOfAccountsAndNews.recomendedAccounts = []
                if error == nil && snapshot != nil {
                    
                    let currentUserAccount = currentUserAccountObject()
                    for document in snapshot!.documents {
                        
                        let documentData = document.data()
                        if documentData["EMAIL"] as! String != UserDefaults.standard.value(forKey: "EMAIL") as! String && !isFollowing(email: documentData["EMAIL"] as! String, followingList:currentUserAccount.followingList){
                            let followingList = documentData["FOLLOWING_LIST"] as! Array<String>
                            let followersList = documentData["FOLLOWERS_LIST"] as! Array<String>
                            let account = Account()
                            account.userName = documentData["USERNAME"] as! String
                            account.profileDescription = documentData["PROFILE_DESCRIPTION"] as! String
                            account.profilePicture = URL(string: documentData["URL_TO_PROFILE_PICTURE"] as! String)!
                            account.followersList = followersList
                            account.followingList = followingList
                            account.email = documentData["EMAIL"] as! String
                            ArrayOfAccountsAndNews.recomendedAccounts.append(account)
                        }
                    }
                    completionHandler(true)
                }
            }
    }
}

func fetchTrendingArticlesOnCurrentUsersNetwork(){
    
    var articleWithTimeStampArray = [ArticlesWithTimeStampAndReactions]()
    
    filterRecentActivityDocuments(){ uniqueDocuments,allDocuments,reactionDictionary in
        for document in uniqueDocuments {
            let documentData = document.data()
            var articleWithTimeStamp = ArticlesWithTimeStampAndReactions()
            var article = Article()
            article.title = documentData["title"] as? String
            article.content = documentData["content"] as? String
            article.description = documentData["description"] as? String
            article.author = documentData["author"] as? String
            article.url = documentData["url"] as? String
            article.urlToImage = documentData["urlToImage"] as? String
            article.publishedAt = documentData["publishedAt"] as? String
            article.source.id = documentData["sourceID"] as? String
            article.source.name = documentData["sourceName"] as? String
            
            articleWithTimeStamp.article = article
            let timeStamp = documentData["reactionMadeAtTime"] as! Timestamp
            articleWithTimeStamp.timeStamp = timeStamp.dateValue()
            articleWithTimeStampArray.append(articleWithTimeStamp)
        }
        
        articleWithTimeStampArray.sort { $0.timeStamp>$1.timeStamp }
        print(reactionDictionary)
    }
    
}

func filterRecentActivityDocuments(completionHandler:@escaping([QueryDocumentSnapshot],[QueryDocumentSnapshot],[String:Reaction])->()){
    var uniqueDocuments = [QueryDocumentSnapshot]()
    fetchRecentActivityDocuments(){ documentsArray in
        let uniqueDocumentIDArray = fetchDocumentID(documentsList: documentsArray)
        for documentID in uniqueDocumentIDArray{
            for document in documentsArray {
                if document.documentID == documentID{
                    uniqueDocuments.append(document)
                    break
                }
            }
        }
        
        var reactionCountDictionary = [String():Reaction()]
        
        for document in uniqueDocuments {
            reactionCountDictionary[document.documentID] = Reaction()
        }
        
        for document in documentsArray {
            let documentData = document.data()
        
            if documentData["reaction"] as? String == ReactionType.positive.rawValue{
                reactionCountDictionary[document.documentID]?.positiveCount+=1
            }
            else if documentData["reaction"] as? String == ReactionType.negative.rawValue{
                reactionCountDictionary[document.documentID]?.negativeCount+=1
            }
            else{
                reactionCountDictionary[document.documentID]?.neutralCount+=1
            }
            
        }
        
        reactionCountDictionary.removeValue(forKey: "")
        print(reactionCountDictionary.count)
        completionHandler(uniqueDocuments,documentsArray,reactionCountDictionary)
        
    }
}

func fetchDocumentID(documentsList:[QueryDocumentSnapshot])->[String]{
    var documentIDArray = [String]()
    for document in documentsList{
        documentIDArray.append(document.documentID)
    }
    let unique = Array(Set(documentIDArray))
    return unique
}

func fetchRecentActivityDocuments(completionHandler:@escaping ([QueryDocumentSnapshot])->()){
    let currentUserAccount = currentUserAccountObject()
    var documentsArray = [QueryDocumentSnapshot]()
    var count = 0
    for users in currentUserAccount.followingList{
        
        ENCDEC.encryptMessage(message: users, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                
                
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/RecentActivity")
                    .getDocuments { (snapshot, error) in
                    
                    if error == nil && snapshot != nil {
                        documentsArray.append(contentsOf: snapshot!.documents)
                    }
                        count+=1
                        if count == currentUserAccount.followingList.count{
                            completionHandler(documentsArray)
                        }
                }
                
                
            }
        }
        
        
    }
}

func isFollowing(email:String,followingList:[String])->Bool{
    for emil in followingList{
        if email==emil{
            return true
        }
    }
    return false
}

func fetchProfilePicture(url:URL,completionHandler:@escaping(Data)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        let dataTask = URLSession.shared.dataTask(with: url){ data,response,error in
            if error == nil{
                completionHandler(data!)
            }
        }
        dataTask.resume()
    }
}

func currentUserAccountObject()->Account{
    let documentData = UserDefaults.standard.value(forKey: "USERMETADATA") as! [String:Any]
    let followingList = documentData["FOLLOWING_LIST"] as! Array<String>
    let followersList = documentData["FOLLOWERS_LIST"] as! Array<String>
    let account = Account()
    account.userName = documentData["USERNAME"] as! String
    account.profileDescription = documentData["PROFILE_DESCRIPTION"] as! String
    account.profilePicture = URL(string: documentData["URL_TO_PROFILE_PICTURE"] as! String)!
    account.followersList = followersList
    account.followingList = followingList
    account.email = documentData["EMAIL"] as! String
    return account
}
