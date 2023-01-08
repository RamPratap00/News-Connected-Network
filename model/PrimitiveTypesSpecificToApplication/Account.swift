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

class ArrayOfAccountsAndNews{
    static var recomendedAccounts = [Account()]
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


func convertToGrayScale(image: UIImage) -> UIImage {

    // Create image rectangle with current image width/height
    let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)

    // Grayscale color space
    let colorSpace = CGColorSpaceCreateDeviceGray()
    let width = image.size.width
    let height = image.size.height

    // Create bitmap content with current image size and grayscale colorspace
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
    context?.draw(image.cgImage!, in: imageRect)
    let imageRef = context!.makeImage()

    // Create a new UIImage object
    let newImage = UIImage(cgImage: imageRef!)

    return newImage
}
