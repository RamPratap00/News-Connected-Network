//
//  MildFetchTasks.swift
//  News Connected Network
//
//  Created by ram-16138 on 15/01/23.
//

import Foundation
import Firebase
import UIKit
import FirebaseFirestore


/// CURRENT USER
internal func currentUserAccountObject()->Account{
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
    account.language = documentData["Language"] as! String
    return account
}

internal func fetchCurrenUserProfileData(completionHandler: @escaping (Bool)->()){
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

internal func fetchCurrentUserProfilePicture(completionHandler:@escaping(Bool)->()){
    let userData = UserDefaults.standard.value(forKey: "USERMETADATA") as! [String:Any]?
    let url = userData!["URL_TO_PROFILE_PICTURE"] as! String
    DispatchQueue.global(qos: .userInteractive).async {
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!){ data,response,error in
            if error == nil{
                UserDefaults.standard.set(data, forKey: "PROFILEPICTURE")
                completionHandler(true)
            }
        }
        dataTask.resume()
    }
}

/// NON-CURRENT USER
internal func fetchUserProfileData(email:String,completionHandler: @escaping (Account)->()){
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
                            fetchCurrentUserRecentActivityDocumentsArray(){ documents in
                                account.recentActivityCount = documents.count
                                completionHandler(account)
                            }
                        }
                        
                    }
                    
                }
        }
    }
}

internal func fetchUserProfilePicture(url:URL,completionHandler:@escaping(Data)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        let dataTask = URLSession.shared.dataTask(with:url){ data,response,error in
            if error == nil{
                completionHandler(data!)
            }
        }
        dataTask.resume()
    }
}

/// Other Fetches
internal func fetchProfilePicture(url:URL,completionHandler:@escaping(Data)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        let dataTask = URLSession.shared.dataTask(with: url){ data,response,error in
            if error == nil{
                completionHandler(data!)
            }
            
        }
        dataTask.resume()
    }
}

internal func fetchDocumentID(documentsList:[QueryDocumentSnapshot])->[String]{
    var documentIDArray = [String]()
    for document in documentsList{
        documentIDArray.append(document.documentID)
    }
    let unique = Array(Set(documentIDArray))
    return unique
}

internal func isFollowing(email:String,followingList:[String])->Bool{
    for emil in followingList{
        if email==emil{
            return true
        }
    }
    return false
}
