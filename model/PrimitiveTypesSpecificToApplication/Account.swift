//
//  Account.swift
//  News Connected Network
//
//  Created by ram-16138 on 31/12/22.
//

import Foundation


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
    var recentActivity = [Article]()
    var email = String()
    
    
    func fetchUserID()->String{
        return "@"+userName
    }
    
}

class ArrayOfAccountsAndNews{
    static var recomendedAccounts = [Account()]
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
