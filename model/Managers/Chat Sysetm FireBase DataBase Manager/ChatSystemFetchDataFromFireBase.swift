//
//  ChatSystemFetchDataFromFireBase.swift
//  News Connected Network
//
//  Created by ram-16138 on 07/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

internal func fetchMessageFromFireBaseChatSystem(sender:Account,completionHandler:@escaping ([QueryDocumentSnapshot])->()){
    fetchCurrenUserProfileData(completionHandler: {_ in})
    let currentUserAccount = currentUserAccountObject()
    DispatchQueue.global(qos: .userInteractive).async {
        ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(sender.email)")
                    .getDocuments { (snapshot, error) in
                    
                    if error == nil && snapshot != nil {
                        
                        completionHandler(snapshot!.documents)
                        
                    }
                        else{print("No chat found")}
                }
                
            }
        }
    }
}

internal func addListner(sendingtUser:Account,completionHandler: @escaping ()->()){
    let currentUserAccount = currentUserAccountObject()
    DispatchQueue.global().async {
        ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(sendingtUser.email)")
                    .addSnapshotListener { documentSnapshot, error in
                        completionHandler()
                    }
            }
        }
    }
}
