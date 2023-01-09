//
//  CSChatViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 06/01/23.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import SafariServices

class CSChatViewController: MessagesViewController {

    var urlToArticle = String()
    var sendingtUser = Account()
    var receivingUser = Account()
    var messages = [Message]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
                    layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
                    layout.textMessageSizeCalculator.incomingAvatarSize = .zero
                    layout.setMessageIncomingAvatarSize(.zero)
                }
        addListner()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.inputTextView.text = urlToArticle
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete Chat", style: .plain, target: self, action: #selector(deleteChat))
        navigationItem.rightBarButtonItem?.tintColor = .red
        // Do any additional setup after loading the view.
    }
    
    
    func addListner(){
        let currentUserAccount = currentUserAccountObject()
        ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(self.sendingtUser.email)")
                    .addSnapshotListener { [self] documentSnapshot, error in
                        print("something happended")
                        reload()
                    }
            }
        }
    }
    
    @objc func deleteChat(){
        let currentUserAccount = currentUserAccountObject()
        ENCDEC.encryptMessage(message: currentUserAccount.email, messageType: .Email){ encryptedEmail in
            ENCDEC.encryptMessage(message: (encryptedEmail+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                let currentUserDataBase = Firestore.firestore()
                currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(self.sendingtUser.email)").getDocuments { (snapshot, error) in
                    
                    if error == nil && snapshot != nil {
                        
                        for document in snapshot!.documents {
                            print(document.documentID)
                            currentUserDataBase.collection("IndividualUsersData/\(encryptedDataBaseName)/\(self.sendingtUser.email)").document(document.documentID).delete()
                            
                        }
                        
                    }
                }
                self.reload()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
    
    
    func reload(){
        messages = []
        fetchMessageFromFireBaseChatSystem(sender: sendingtUser){ documents in
            
            for document in documents {
                
                let documentData = document.data()
                let timeStamp = documentData["sentDate"] as! Timestamp
                let message = Message(sender: Sender(senderId: documentData["senderId"] as! String, displayName: documentData["displayName"] as! String),
                                      messageId: documentData["messageId"] as! String,
                                      sentDate: timeStamp.dateValue(),
                                      kind: .text(documentData["message"] as! String))
                self.messages.append(message)
            }
            self.messages.sort { $0.sentDate<$1.sentDate }
                self.messagesCollectionView.reloadData()
            
        }
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


extension CSChatViewController:MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    var currentSender: MessageKit.SenderType {
        return Sender(senderId: sendingtUser.email, displayName: sendingtUser.userName)
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

extension CSChatViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if text != "" && text != " "{

            let newMessage = Message(sender: Sender(senderId: sendingtUser.email, displayName: sendingtUser.userName),
                                   messageId: sendingtUser.email+"<|||>"+sendingtUser.fetchUserID(),
                                   sentDate: Date(),
                                   kind: .text(text))

            putNewMessageToFireBaseChatSystem(sender: sendingtUser, receiver: receivingUser, message: newMessage,contentOfTheMessage: text)
            messages.append(newMessage)
            messagesCollectionView.reloadData()

            messageInputBar.inputTextView.text = nil
        }
        else{
            print("nothing to send")
        }

    }

}

extension CSChatViewController: MessageCellDelegate{
    func didTapMessage(in cell: MessageCollectionViewCell) {
            print("Message tapped")
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
                    let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                        return
                }
        if case .text(let value) = message.kind.self {
            let url = URL(string: value)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true)
            }
        
        }
}
