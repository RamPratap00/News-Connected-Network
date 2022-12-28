//
//  LocalUserAccountDataBaseManager.swift
//  NCN news app
//
//  Created by ram-16138 on 26/12/22.
//

import Foundation
import SQLite3
import UIKit


enum TablesForIndividualUser:String{
    case basicSetOfData
}

class LocalUserAccountDataBaseManager{
    var database:DataBase
    var dataBaseName:String
    init(dataBaseName:String) {
        self.dataBaseName = dataBaseName
        self.database = DataBase(databasename: dataBaseName)
    }
    
    
    func createTableForStoringDataOfAnIndividualUser(userName:String){
        DispatchQueue.global(qos: .userInitiated).async {
            self.database.createTable(columnNameWithDataTypes: "USERNAME TEXT, FOLLOWERS_COUNT INT ,FOLLOWING_COUNT INT, PROFILE_DESCRIPTION,PROFILE_PICTURE BLOB", tableName: TablesForIndividualUser.basicSetOfData.rawValue)
            
            let query = "INSERT INTO \(TablesForIndividualUser.basicSetOfData.rawValue) VALUES(?,?,?,?,?);"
            var insertStatement:OpaquePointer?
            if sqlite3_prepare_v2(self.database.dataBasePointer, query, -1, &insertStatement, nil) == SQLITE_OK{
                
                // name preparation
                let userName:NSString = NSString(string: userName)
                sqlite3_bind_text(insertStatement, 1, userName.utf8String, -1, nil)
                // dob string preparation
                let followersCount = 0
                sqlite3_bind_int(insertStatement, 2, Int32(followersCount))
                
                let followingCount = 0
                sqlite3_bind_int(insertStatement, 3, Int32(followingCount))
                
                let profileDescription:NSString = NSString(string: "")
                sqlite3_bind_text(insertStatement, 4, profileDescription.utf8String, -1, nil)
                
                let defaultImage = UIImage(imageLiteralResourceName: "login Background")
                if let imageData = defaultImage.pngData(){
                    imageData.withUnsafeBytes { buffer in
                        let imagePtr = buffer.baseAddress!
                        sqlite3_bind_blob(insertStatement, 5, imagePtr, Int32(buffer.count), nil)
                    }
                }
                
                //            let rawUnsafePointer = sqlite3_column_blob(select, 0)!
                //            let rawLen:Int32 = sqlite3_column_bytes(select, 0)
                //            let data = Data(bytes: rawUnsafePointer, count: Int(rawLen)) use this for reading!
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    print("data inserted")
                    sqlite3_finalize(insertStatement)
                }
                else{
                    print(sqlite3_step(insertStatement))
                    sqlite3_finalize(insertStatement)
                    print("insertion failure")
                    return
                }
            }
            else{
                sqlite3_finalize(insertStatement)
                print("preparation failure of insertion query")
                return
            }
        }
        
    }
    
    func insertUserNameAndImageIntoTableOfTypeUsers(
        email_id:String,
        password:String,
        databaseName:String
        )->Bool{
            return true
    }
    
    func closeDataBase(){
        if sqlite3_close(database.dataBasePointer) != SQLITE_OK {
            print("error closing database \(dataBaseName)")
        }
        else{
            print("database closed")
        }
    }
    
    static func updateProfilePicture(image:UIImage,email:String){
        DispatchQueue.global(qos: .userInitiated).async {
            let globalDataBaseInstance = GlobalUserAccountDataBaseManager(dataBaseName: "UserAccountDataBase")
            let encryptedDataBaseName = globalDataBaseInstance.fetchDataBaseForTheCurrentUser(email: email, dataBaseInstance: globalDataBaseInstance)
            ENCDEC.decryptMessage(encryptedMessage: encryptedDataBaseName, messageType: KEY.DataBaseName){ dataBaseName in
                let currentDataBase = LocalUserAccountDataBaseManager(dataBaseName: dataBaseName)
                let updateQueryString = "Update \(TablesForIndividualUser.basicSetOfData.rawValue) set PROFILE_PICTURE=?"
                var updateStatement:OpaquePointer?
                if sqlite3_prepare_v2(currentDataBase.database.dataBasePointer, updateQueryString, -1, &updateStatement, nil) == SQLITE_OK{
                    
                    if let imageData = image.pngData(){
                        imageData.withUnsafeBytes { buffer in
                            let imagePtr = buffer.baseAddress!
                            sqlite3_bind_blob(updateStatement, 1, imagePtr, Int32(buffer.count), nil)
                        }
                    }
                    
                    if sqlite3_step(updateStatement) == SQLITE_DONE{
                        print("data updated")
                        sqlite3_finalize(updateStatement)
                    }
                    else{
                        print(sqlite3_step(updateStatement))
                        sqlite3_finalize(updateStatement)
                        print("updation failure")
                        return
                    }
                    
                }
                else{
                    sqlite3_finalize(updateStatement)
                    print("preparation failure of updation query")
                    return
                }
                currentDataBase.closeDataBase()
            }
            globalDataBaseInstance.closeDataBase()
        }
    }
    
}
