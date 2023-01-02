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

func uploadDefaultUserDataToFireBase(email:String,password:String,userName:String,completionHandler : @escaping (Bool,String?)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password){ authResult,error in
            if error == nil{
                let allUserDataBase = Firestore.firestore()
                let currentUserDataBase = Firestore.firestore()
                ENCDEC.encryptMessage(message: email,messageType: .Email){ encryptedEmail in
                    ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                        allUserDataBase.collection("ALLUSERSLIST").document(encryptedEmail).setData(["email":encryptedEmail,"correspondingCollectionName":encryptedDataBaseName])
                        let data = UIImage(imageLiteralResourceName: "login Background").pngData()!
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
                                currentUserDataBase.collection("IndividualUsersData").document(encryptedDataBaseName).setData(["USERNAME":userName, "PROFILE_DESCRIPTION":" ","URL_TO_PROFILE_PICTURE":downloadURL.absoluteString,"FOLLOWERS_LIST":[],"FOLLOWING_LIST":[], "RECENT_ACTIVITY":[],"EMAIL":email])
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


func login(email:String,password:String,completionHandler:@escaping (Bool)->()){
    DispatchQueue.global(qos: .userInitiated).async {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password){ authResult,error in
            guard let _ = authResult ,error == nil else{
                completionHandler(false)
                return
            }
            ENCDEC.encryptMessage(message: email, messageType: .Email){encryptedEmail in
                UserDefaults.standard.set(String(email), forKey: "EMAIL")
                UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
                fetchCurrenUserProfileData(){ _ in
                    completionHandler(true)
                }
            }
        }
    }
}

func updateFireBaseFollowersFollowing(currentUserAccount:Account,nonCurrentUserAccount:Account){
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
