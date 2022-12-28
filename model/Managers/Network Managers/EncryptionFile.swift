//
//  EncryptionFile.swift
//  NCN news app
//
//  Created by ram-16138 on 25/12/22.
//
/// THIS SWIFT FILE IS USED TO ENCRYPT AND DECRYPT MESSAGES
import Foundation
import CryptoSwift

struct ENCDEC{
    /// this function is used to encrypt any given message.
    /// - Parameters:
    ///   - message: data which needs to be encrypted.
    ///   - encryptionKey: 16 character length key to encrypt.
    ///   - iv: 16 character length key to encrypt.
    /// - Returns: encrypted message
    static func encryptMessage(message: String,messageType:KEY,encryptedDataCompletionHandler: @escaping (String)->()) {
        
        ENCDEC.makeNetworkCallforFetchingKey(messageType: messageType){ key in
            if let aes = try? AES(key: key.encryptionKey, iv: key.ivKey),
               let encrypted = try? aes.encrypt(Array<UInt8>(message.utf8)) {
                encryptedDataCompletionHandler(  encrypted.toHexString() )
            }
        }
    }
    
    /// this function is used to decrypt any given message.
    /// - Parameters:
    ///   - message: data which needs to be decrypted.
    ///   - encryptionKey: 16 character length key to decrypt.
    ///   - iv: 16 character length key to decrypt.
    /// - Returns: decrypted message
    static func decryptMessage(encryptedMessage: String,messageType:KEY,decryptedDataCompletionHandler: @escaping (String)->()) {
        
        ENCDEC.makeNetworkCallforFetchingKey(messageType: messageType){ key in
            if let aes = try? AES(key: key.encryptionKey, iv: key.ivKey),
               let decrypted = try? aes.decrypt(Array<UInt8>(hex: encryptedMessage)) {
                decryptedDataCompletionHandler( String(data: Data(decrypted), encoding: .utf8)! )
            }
        }
    }
    
    static func makeNetworkCallforFetchingKey(messageType:KEY,keyCompletionHandler: @escaping (SecretKey)->()){
        DispatchQueue.global(qos: .userInteractive).async {
            let urlString = "https://2bc5601e-11a2-4eaa-a2f5-1f1e29e6fa2b.mock.pstmn.io/" + messageType.rawValue
            let dataTask = URLSession.shared.dataTask(with: URL(string: urlString)!){ data,response,error in
                if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let key = try decoder.decode(SecretKey.self, from: data!)
                    keyCompletionHandler(key)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            dataTask.resume()
        }
    }
    
    static func isStrongPassword(password: String) -> Bool {
      // Minimum length for a strong password is 8 characters
      if password.count < 8 {
        return false
      }

      // Check if the password has at least one uppercase letter
      let upperCaseRegEx  = ".*[A-Z]+.*"
      let upperCaseTest = NSPredicate(format:"SELF MATCHES %@", upperCaseRegEx)
      if !upperCaseTest.evaluate(with: password) {
        return false
      }

      // Check if the password has at least one lowercase letter
      let lowerCaseRegEx  = ".*[a-z]+.*"
      let lowerCaseTest = NSPredicate(format:"SELF MATCHES %@", lowerCaseRegEx)
      if !lowerCaseTest.evaluate(with: password) {
        return false
      }

      // Check if the password has at least one digit
      let numberRegEx  = ".*[0-9]+.*"
      let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
      if !numberTest.evaluate(with: password) {
        return false
      }

      // Check if the password has at least one special character
      let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
      let specialCharacterTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
      if !specialCharacterTest.evaluate(with: password) {
        return false
      }

      // If all checks pass, the password is strong
      return true
    }
}

enum KEY:String{
    case Password
    case Email
    case DataBaseName
}
struct SecretKey:Codable{
    let encryptionKey:String
    let ivKey:String
}
