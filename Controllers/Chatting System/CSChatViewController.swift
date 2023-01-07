//
//  CSChatViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 06/01/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message:MessageType{
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender:SenderType{
    var senderId: String
    var displayName: String
}

class CSChatViewController: MessagesViewController {

    var sendingtUser = Account()
    var receivingUser = Account()
    var messages = [Message]()
    var sender = Sender(senderId: "", displayName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sender.senderId = sendingtUser.email
        sender.displayName = sendingtUser.userName
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesCollectionView.reloadData()
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
        return sender
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
            print("Sending: \(text)")
            
            let newMessage = Message(sender: sender,
                                   messageId: sendingtUser.email+"<|||>"+sendingtUser.fetchUserID(),
                                   sentDate: Date(),
                                   kind: .text(text))
            
            messages.append(newMessage)
            messagesCollectionView.reloadData()
            
            messageInputBar.inputTextView.text = nil
        }
        else{
            print("nothing to send")
        }

    }

}
