//
//  MiscFunctions.swift
//  News Connected Network
//
//  Created by ram-16138 on 15/01/23.
//

import Foundation
import UIKit

internal func languageKey(lang:String)->Language{
    var language = ""
    if lang == ""{
        language = "English"
    }
    else{
        language = lang
    }
    return Language(rawValue: language)!
}

internal func convertToGrayScale(image: UIImage) -> UIImage {

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

internal func applyBorderForButton(button:UIButton){
    button.layer.borderWidth = 1.5
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.cornerRadius = 17
    button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
    button.layer.masksToBounds = true
}

internal func applyBorderForTextField(textField:UITextField){
    textField.layer.borderWidth = 2
    textField.layer.borderColor = UIColor.gray.cgColor
    textField.layer.cornerRadius = 17
    textField.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
    textField.layer.masksToBounds = true
}

internal func isValidEmail(email: String) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  return emailPred.evaluate(with: email)
}


internal func isFollowing(email:String,followingList:[String])->Bool{
    for emil in followingList{
        if email==emil{
            return true
        }
    }
    return false
}
