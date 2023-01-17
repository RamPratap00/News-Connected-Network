//
//  Account.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import Foundation
import UIKit


class Account:Equatable{
    static func == (lhs: Account, rhs: Account) -> Bool {
        if lhs.email == rhs.email{
            return true
        }
        else{
            return false
        }
    }
    
    var userName = String()
    var profileDescription = String()
    var profilePicture = URL(string: String())
    var followersList = [String]()
    var followingList = [String]()
    var recentActivityCount = Int()
    var email = String()
    var language = String()
    
    
    func fetchUserID()->String{
        return "@"+userName
    }
    
}

struct ArticlesWithTimeStampAndReactions{
    var article = Article()
    var timeStamp = Date()
    var reaction = Reaction()
}

struct Reaction{
    var positiveCount = 0
    var negativeCount = 0
    var neutralCount = 0
}

enum ReactionType:String{
    case positive
    case negative
    case neutral
}
