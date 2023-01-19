//
//  PutDataToFireBase.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

internal func uploadDefaultUserDataToFireBase(email:String,password:String,userName:String,completionHandler : @escaping (Bool,String?)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password){ authResult,error in
            if error == nil{
                let allUserDataBase = Firestore.firestore()
                let currentUserDataBase = Firestore.firestore()
                ENCDEC.encryptMessage(message: email,messageType: .Email){ encryptedEmail in
                    ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                        allUserDataBase.collection("ALLUSERSLIST").document(encryptedEmail).setData(["email":encryptedEmail,"correspondingCollectionName":encryptedDataBaseName])
                        let data = UIImage(imageLiteralResourceName: "profile image 1").pngData()!
                        let storageRef = Storage.storage().reference()
                        let fireBaseRef = storageRef.child("images/\(encryptedEmail).jpg")
                        
                        // Upload the file to the path "images/rivers.jpg"
                        _ = fireBaseRef.putData(data, metadata: nil) { (metadata, error) in
                            // You can also access to download URL after upload.
                            fireBaseRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    return
                                }
                                currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).setData(["USERNAME":userName, "PROFILE_DESCRIPTION":" ","URL_TO_PROFILE_PICTURE":downloadURL.absoluteString,"FOLLOWERS_LIST":[],"FOLLOWING_LIST":[],"EMAIL":email,"Language":"English"])
                            }
                        }
                        
                        completionHandler(true,encryptedEmail)
                    }
                }
            }
            else{
                completionHandler(false,nil)
            }
        }
    }
}

internal func login(email:String,password:String,completionHandler:@escaping (Bool)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password){ authResult,error in
            guard let _ = authResult ,error == nil else{
                completionHandler(false)
                return
            }
            ENCDEC.encryptMessage(message: email, messageType: .Email){encryptedEmail in
                UserDefaults.standard.set(String(email), forKey: "EMAIL")
                UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
                fetchUserProfileData(isCurrentUser: true, email: email){ _ in
                    completionHandler(true)
                }
            }
        }
    }
}

internal func uploadingImageAndLanguageToFireBase(email:String,data:Data,language:String,completionHandler:@escaping (Bool)->()){
    ENCDEC.encryptMessage(message: email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
            let storageRef = Storage.storage().reference()
            let fireBaseRef = storageRef.child("images/\(encryptedEmail).jpg")
            
            // Upload the file to the path "images/email-encrypted.jpg"
            _ = fireBaseRef.putData(data, metadata: nil) { (metadata, error) in
                // You can also access to download URL after upload.
                fireBaseRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).updateData(["URL_TO_PROFILE_PICTURE":downloadURL.absoluteString])
                    currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).updateData(["Language":language])

                    completionHandler(true)
                }
            }
        }
    }
}

internal func updatingProfileImage(email:String,data:Data,completionHandler:@escaping (Bool)->()){
    ENCDEC.encryptMessage(message: email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
            let storageRef = Storage.storage().reference()
            let fireBaseRef = storageRef.child("images/\(encryptedEmail).jpg")
            
            // Upload the file to the path "images/email-encrypted.jpg"
            _ = fireBaseRef.putData(data, metadata: nil) { (metadata, error) in
                // You can also access to download URL after upload.
                fireBaseRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).updateData(["URL_TO_PROFILE_PICTURE":downloadURL.absoluteString])

                    completionHandler(true)
                }
            }
        }
    }
}

internal func updateProfileDescription(content:String){
    let currentUserAccount = currentLoggedInUserAccount()
    ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
            currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).updateData(["PROFILE_DESCRIPTION":content])
        }
    }
}

internal func updateFireBaseRecentActivityStack(article:Article,reaction:String){
    let currentUserAccount = currentLoggedInUserAccount()
    let articleUniqueSignature = (article.source.name!+" !!! NEWS CONNECTED NETWORK !!! "+article.title!)
    ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
            currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/RecentActivity").document(articleUniqueSignature).setData(["sourceID":article.source.id as Any,"sourceName":article.source.name as Any,"author":article.author as Any,"title":article.title as Any,"description":article.description as Any,"url":article.url as Any,"urlToImage":article.urlToImage as Any,"publishedAt":article.publishedAt as Any,"content":article.content as Any,"reaction":reaction,"reactionMadeAtTime":Date.now])
        }
    }
}


internal func updateFireBaseFollowersFollowing(currentUserAccount:Account,nonCurrentUserAccount:Account){
    
    ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).updateData(["FOLLOWING_LIST":currentUserAccount.followingList])
        }
    }
    
    ENCDEC.encryptMessage(message: nonCurrentUserAccount.email, messageType: .Email){ encryptedEmail in
        ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
            let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).updateData(["FOLLOWERS_LIST":nonCurrentUserAccount.followersList])
        }
    }
    
}
