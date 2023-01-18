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
internal func currentLoggedInUserAccount()->Account{
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

/// NON-CURRENT USER
internal func fetchUserProfileData(isCurrentUser:Bool?,email:String,completionHandler: @escaping (Account)->()){
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
                            fetchCurrentlyLoggedInUserRecentActivityDocumentsArray(){ documents in
                                account.recentActivityCount = documents.count
                                if isCurrentUser == true{
                                    UserDefaults.standard.set(documentData, forKey: "USERMETADATA")
                                }
                                completionHandler(account)
                            }
                        }
                        
                    }
                    
                }
        }
    }
}

/// Other Fetches
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
