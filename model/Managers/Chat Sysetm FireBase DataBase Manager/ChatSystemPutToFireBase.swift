//
//  ChatSystemPutToFireBase.swift
//  News Connected Network
//
//  Created by ram-16138 on 07/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

func putNewMessageToFireBaseChatSystem(sender:Account,receiver:Account,message:Message,contentOfTheMessage:String){
    DispatchQueue.global().async {
        fetchCurrenUserProfileData(completionHandler: {_ in})
        ENCDEC.encryptMessage(message: sender.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(receiver.email)").addDocument(data: ["senderId":message.sender.senderId,
                                                                                                           "displayName":message.sender.displayName,
                                                                                                           "messageId":message.messageId,
                                                                                                           "sentDate":message.sentDate,
                                                                                                           "message":contentOfTheMessage])
            }
        }
        ENCDEC.encryptMessage(message: receiver.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(sender.email)").addDocument(data: ["senderId":message.sender.senderId,
                                                                                                           "displayName":message.sender.displayName,
                                                                                                           "messageId":message.messageId,
                                                                                                           "sentDate":message.sentDate,
                                                                                                           "message":contentOfTheMessage])
            }
        }
    }
    
}

func deleteChatFromFireBase(sendingtUser:Account,completionHandler: @escaping ()->()){
    let currentUserAccount = currentUserAccountObject()
    DispatchQueue.global().async {
        ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(sendingtUser.email)").getDocuments { (snapshot, error) in
                    
                    if error == nil && snapshot != nil {
                        
                        for document in snapshot!.documents {
                            currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(sendingtUser.email)").document(document.documentID).delete()
                            
                        }
                        
                    }
                }
                completionHandler()
            }
        }
    }
}
