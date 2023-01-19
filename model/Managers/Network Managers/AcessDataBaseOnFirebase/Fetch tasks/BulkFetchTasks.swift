//
//  BulkFetchTasks.swift
//  News Connected Network
//
//  Created by ram-16138 on 15/01/23.
//

import Foundation
import Firebase
import UIKit
import FirebaseFirestore


/// Fetches array of accounts based on request
internal func fetchArrayOfAccountsForGivenEmailList(emailArray:[String],completionHandler: @escaping ([Account])->()){
    var arrayOfAccounts = [Account]()
    var count = 0
    for email in emailArray{
        fetchUserProfileData(isCurrentUser:false,email: email){ account in
            count+=1
            arrayOfAccounts.append(account)
            if count == emailArray.count{
                completionHandler(arrayOfAccounts)
            }
        }
    }
}

/// Fetchs array of article with timestamp and reaction
/// CURRENT USER
internal func fetchTrendingArticlesOnCurrentlyLoggedInUserNetwork(completionHandler: @escaping ([ArticleWithTimeStampAndReactions])->()){
    
    var articleWithTimeStampArray = [ArticleWithTimeStampAndReactions]()
    
    filterRecentActivityDocumentsFromNetwork(){ uniqueDocuments,allDocuments,reactionDictionary in
        var articleWithTimeStamp = ArticleWithTimeStampAndReactions()
        for document in uniqueDocuments {
            let documentData = document.data()
            
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
            
            articleWithTimeStamp.reaction = reactionDictionary[article.source.name!+" !!! NEWS CONNECTED NETWORK !!! "+article.title!]!
            
            articleWithTimeStampArray.append(articleWithTimeStamp)
        }
        
        articleWithTimeStampArray.sort { $0.timeStamp>$1.timeStamp }
        completionHandler(articleWithTimeStampArray)
    }
}

internal func filterRecentActivityDocumentsFromNetwork(completionHandler:@escaping([QueryDocumentSnapshot],[QueryDocumentSnapshot],[String:Reaction])->()){
    var uniqueDocuments = [QueryDocumentSnapshot]()
    fetchRecentActivityDocumentsFromCurrentlyLoggedInUsersNetwork(){ documentsArray in
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
        completionHandler(uniqueDocuments,documentsArray,reactionCountDictionary)
        
    }
}

internal func fetchRecentActivityDocumentsFromCurrentlyLoggedInUsersNetwork(completionHandler:@escaping ([QueryDocumentSnapshot])->()){
    let currentUserAccount = currentLoggedInUserAccount()
    var documentsArray = [QueryDocumentSnapshot]()
    var count = 0
    if currentUserAccount.followingList.count == 0{
        fetchUserRecentActivityDocuments(email: currentUserAccount.email){ documents in
            documentsArray.append(contentsOf: documents)
            completionHandler(documentsArray)
        }
    }
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
                            fetchUserRecentActivityDocuments(email: currentUserAccount.email){ documents in
                                documentsArray.append(contentsOf: documents)
                                completionHandler(documentsArray)
                            }
                        }
                }
                
                
            }
        }
        
        
    }
}

/// NON-CURRENT USER
internal func fetchUserRecentActivity(email:String,completionHandler:@escaping ([Article])->()){
    var articles = [Article]()
    fetchUserRecentActivityDocuments(email: email){ documentsArray in
        for document in documentsArray{
            let documentData = document.data()
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
            
            articles.append(article)
            
        }
        completionHandler(articles)
    }
}

internal func fetchUserRecentActivityDocuments(email:String,completionHandler:@escaping ([QueryDocumentSnapshot])->()){
    
    ENCDEC.encryptMessage(message: email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
            
            
            currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/RecentActivity")
                .getDocuments { (snapshot, error) in
                
                if error == nil && snapshot != nil {
                   completionHandler(snapshot!.documents)
                }
            }
            
            
        }
    }
    
}

/// Global Network

internal func fetchRecentActivityDocumentsOfAllUsers(completionHandler:@escaping ([QueryDocumentSnapshot])->()){
    var documentsArray = [QueryDocumentSnapshot]()
    let currentUserDataBase = Firestore.firestore()
    var count = 0
    fetchAllUsersDocumentID(){ documentsIdArray in
        
        for currentDocumentId in documentsIdArray{
            currentUserDataBase.collection("IndividualUsersData/\(currentDocumentId)/RecentActivity").getDocuments { (snapshot, error) in
                documentsArray.append(contentsOf: snapshot!.documents)
                count+=1
                if count == documentsIdArray.count{
                    completionHandler(documentsArray)
                }
            }
        }
    }
        
}

/// Fetches array of accounts for recomendation and search
internal func fetchUsersForRecomendation(completionHandler:@escaping ([Account])->()){
    DispatchQueue.global().async{
        var arrayOfAccounts = [Account]()
        let db = Firestore.firestore()
        db.collection("IndividualUsersData")
            .limit(to:100)
            .getDocuments { (snapshot, error) in
                if error == nil && snapshot != nil {
                    
                    let currentUserAccount = currentLoggedInUserAccount()
                    for document in snapshot!.documents {
                        
                        let documentData = document.data()
                        if documentData["EMAIL"] as! String != currentUserAccount.email && !isFollowing(email: documentData["EMAIL"] as! String, followingList:currentUserAccount.followingList){
                            let followingList = documentData["FOLLOWING_LIST"] as! Array<String>
                            let followersList = documentData["FOLLOWERS_LIST"] as! Array<String>
                            let account = Account()
                            account.userName = documentData["USERNAME"] as! String
                            account.profileDescription = documentData["PROFILE_DESCRIPTION"] as! String
                            account.profilePicture = URL(string: documentData["URL_TO_PROFILE_PICTURE"] as! String)!
                            account.followersList = followersList
                            account.followingList = followingList
                            account.email = documentData["EMAIL"] as! String
                            account.language = documentData["Language"] as! String
                            arrayOfAccounts.append(account)
                        }
                    }
                    completionHandler(arrayOfAccounts)
                }
            }
    }
}

//internal func fetchLayerTwoUsersForRecommendation(completionHandler:@escaping ([Account])->()){
//    let currentUser = currentLoggedInUserAccount()
//    var userList = [String]()
//    var layerTwoAccountList = [String]()
//    userList.append(contentsOf: currentUser.followersList)
//    userList.append(contentsOf: currentUser.followingList)
//    fetchArrayOfAccountsForGivenEmailList(emailArray: userList){ accounts in
//        layerTwoAccountList.append(contentsOf: currentUser.followersList)
//        for account in accounts{
//            layerTwoAccountList.append(contentsOf: account.followersList)
//        }
//        let set1:Set<String> = Set(layerTwoAccountList)
//        let set2:Set<String> = Set(currentUser.followingList)
//        let uniqueLayerTwoAccounts = Array(set1.subtracting(set2))
//        fetchArrayOfAccountsForGivenEmailList(emailArray: uniqueLayerTwoAccounts){ layerTwoAccountsArray in
//            completionHandler(layerTwoAccountsArray)
//        }
//    }
//}

/// Fetch array of articles from global users network
internal func fetchTrendingArticlesOnGlobalUsersNetwork(completionHandler: @escaping ([ArticleWithTimeStampAndReactions])->()){
    
    var articleWithTimeStampArray = [ArticleWithTimeStampAndReactions]()
    
    filterRecentActivityDocumentsFromNetwork(){ uniqueDocuments,allDocuments,reactionDictionary in
        var articleWithTimeStamp = ArticleWithTimeStampAndReactions()
        for document in uniqueDocuments {
            let documentData = document.data()
            
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
            
            articleWithTimeStamp.reaction = reactionDictionary[article.source.name!+" !!! NEWS CONNECTED NETWORK !!! "+article.title!]!
            
            articleWithTimeStampArray.append(articleWithTimeStamp)
        }
        
        articleWithTimeStampArray.sort { $0.timeStamp>$1.timeStamp }
        completionHandler(articleWithTimeStampArray)
    }
}

internal func fetchAllUsersDocumentID(completionHandler:@escaping ([String])->()){
    let db = Firestore.firestore()
    var documentIDArray = [String]()
    db.collection("IndividualUsersData").getDocuments { (snapshot, error) in
        
        if error == nil && snapshot != nil {
            
            for document in snapshot!.documents {
                documentIDArray.append(document.documentID)
            }
            completionHandler(documentIDArray)
        }

        
    }
}
