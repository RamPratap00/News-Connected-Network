//
//  Chat.swift
//  News Connected Network
//
//  Created by ram-16138 on 07/01/23.
//

import Foundation
import MessageKit

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
