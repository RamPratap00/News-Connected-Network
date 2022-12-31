//
//  FetchDataFromFireBase.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import Foundation
import Firebase
import UIKit

func fetchCurrenUserProfileData(completionHandler: @escaping (Bool)->()){
    let db = Firestore.firestore()
    let encryptedEmail = UserDefaults.standard.value(forKey: "EMAIL") as! String
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
                    fetchUserProfilePicture(){_ in completionHandler(true)}
                }
                
            }
            
        }
    }
}

func fetchUserName()->String{
    let userData = UserDefaults.standard.value(forKey: "USERMETADATA") as! [String:Any]?
    return userData!["USERNAME"] as! String
}

func fetchUserProfilePicture(completionHandler:@escaping(Bool)->()){
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
