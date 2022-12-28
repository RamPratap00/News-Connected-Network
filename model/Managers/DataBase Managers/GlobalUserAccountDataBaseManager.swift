//
//  GlobalUserAccountDataBaseManager.swift
//  NCN news app
//
//  Created by ram-16138 on 26/12/22.
//

import Foundation
import SQLite3

class GlobalUserAccountDataBaseManager{
    var database:DataBase
    var dataBaseName:String
    init(dataBaseName:String) {
        self.dataBaseName = dataBaseName
        self.database = DataBase(databasename: dataBaseName)
        createTableForStoringUsers()
    }
    
    /// Creates a new table for storing useraccount.
    /// - Parameters:
    func createTableForStoringUsers(){
        database.createTable(columnNameWithDataTypes: "EMAIL_ID TEXT,PASSWORD TEXT,DATABASE_NAME TEXT", tableName: UserAccountDataBaseTableNames.USER.rawValue)
    }
    
    /// Inserts data into table of type user account
    /// - Parameters:
    ///   - email_id:  email id.
    ///   - password: secure password.
    ///   - databaseName: encrypted name of the database.
    /// - Returns: status of insertion operation.
    func insertIntoTableOfTypeUsers(
        email_id:String,
        password:String,
        databaseName:String
        )->Bool{
            let query = "INSERT INTO \(UserAccountDataBaseTableNames.USER.rawValue) VALUES(?,?,?);"

        var insertStatement:OpaquePointer?
        if sqlite3_prepare_v2(database.dataBasePointer, query, -1, &insertStatement, nil) == SQLITE_OK{
            
            // name preparation
            let email_id:NSString = NSString(string: email_id)
            sqlite3_bind_text(insertStatement, 1, email_id.utf8String, -1, nil)
            // dob string preparation
            let password:NSString = NSString(string: password)
            sqlite3_bind_text(insertStatement, 2, password.utf8String, -1, nil)
            
            let databaseName:NSString = NSString(string: databaseName)
            sqlite3_bind_text(insertStatement, 3, databaseName.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("data inserted")
                sqlite3_finalize(insertStatement)
            }
            else{
                print(sqlite3_step(insertStatement))
                sqlite3_finalize(insertStatement)
                print("insertion failure")
                return false
            }
        }
        else{
            sqlite3_finalize(insertStatement)
            print("preparation failure of insertion query")
            return false
        }
            return true
    }
    
    func checkUserNameAlreadyExists(email:String)->Bool{
        let data = database.readWithConstrains(query: "SELECT EMAIL_ID FROM \(UserAccountDataBaseTableNames.USER.rawValue) WHERE EMAIL_ID='\(email)';")
        while( sqlite3_step(data) == SQLITE_ROW ){
           sqlite3_finalize(data)
            return true
        }
        sqlite3_finalize(data)
        return false
    }
    
    func eraseDataBase(){
        for table in UserAccountDataBaseTableNames.allCases{
            database.dropTable(tableName: table.rawValue)
        }
    }
    
    func closeDataBase(){
        if sqlite3_close(database.dataBasePointer) != SQLITE_OK {
            print("error closing database \(sqlite3_close(database.dataBasePointer) )")
        }
        else{
            print("database closed")
        }
    }
    
    func verifyUserNamePassword(email:String,password:String)->Bool{
        let emailAndPasswordQueryStatement = "SELECT EMAIL_ID,PASSWORD FROM \(UserAccountDataBaseTableNames.USER.rawValue) WHERE EMAIL_ID = '\(email)'"
        let fetchedData = database.readWithConstrains(query: emailAndPasswordQueryStatement)
        while( sqlite3_step(fetchedData) == SQLITE_ROW ){
            let passwordFromDataBase = String(cString: sqlite3_column_text(fetchedData, 1))
            if passwordFromDataBase == password{
                sqlite3_finalize(fetchedData)
                return true
            }
        }
        sqlite3_finalize(fetchedData)
        return false
    }
    
    static func dataBaseAsyncCallToAddUser(email:String,password:String,userName:String,completionHandler: @escaping (String,String?)->()){
        DispatchQueue.global(qos: .userInitiated).async {
            
            ENCDEC.encryptMessage(message: email,messageType: .Email){ encryptedEmail in
                ENCDEC.encryptMessage(message: password,messageType: .Password){ encryptedPassword in
                    ENCDEC.encryptMessage(message: (encryptedEmail+encryptedPassword+encryptedEmail),messageType: .DataBaseName){ encryptedDataBaseName in
                        let dataBase = GlobalUserAccountDataBaseManager(dataBaseName: "UserAccountDataBase")
                        if !dataBase.checkUserNameAlreadyExists(email: encryptedEmail){
                            DispatchQueue.global(qos: .userInitiated).sync {
                                if dataBase.insertIntoTableOfTypeUsers(email_id: encryptedEmail,
                                                                password: encryptedPassword,
                                                                       databaseName: encryptedDataBaseName){
                                    let dataBaseForNewlyAddedUser = LocalUserAccountDataBaseManager(dataBaseName: encryptedEmail+encryptedPassword+encryptedEmail)
                                    dataBaseForNewlyAddedUser.createTableForStoringDataOfAnIndividualUser(userName: userName)
                                    completionHandler("user added",encryptedEmail)
                                }
                            }
                        }
                        else{ completionHandler("user already exist",nil) }
                        dataBase.closeDataBase()
                    }
                }
            }
        }
    }
    
    static func checkMinimumLoginRequirement(email:String,password:String,loginUICompletionHandler: @escaping(String)->()){
        if password == "" || email == ""{
            loginUICompletionHandler("one or more data missing")
            return
        }
            DispatchQueue.global(qos: .userInitiated).async {
                ENCDEC.encryptMessage(message: email,messageType: .Email){ encryptedEmail in
                    ENCDEC.encryptMessage(message: password,messageType: .Password){ encryptedPassword in
                        let dataBase = GlobalUserAccountDataBaseManager(dataBaseName: "UserAccountDataBase")
                        if dataBase.checkUserNameAlreadyExists(email: encryptedEmail){
                            if dataBase.verifyUserNamePassword(email: encryptedEmail, password: encryptedPassword){
                                loginUICompletionHandler("log in")
                            }
                            else{
                                loginUICompletionHandler("wrong password")
                            }
                        }
                        else{
                            loginUICompletionHandler("user name does not exist")
                        }
                        dataBase.closeDataBase()
                    }
                }
            }
    }
    
    
    func fetchDataBaseForTheCurrentUser(email:String,dataBaseInstance:GlobalUserAccountDataBaseManager)->String{
        let fetchDataBaseQueryStatement = "SELECT DATABASE_NAME FROM \(UserAccountDataBaseTableNames.USER.rawValue) WHERE EMAIL_ID = '\(email)'"
        let fetchedData = dataBaseInstance.database.readWithConstrains(query: fetchDataBaseQueryStatement)
        var dataBaseName = String()
        while( sqlite3_step(fetchedData) == SQLITE_ROW ){
            dataBaseName = String(cString: sqlite3_column_text(fetchedData, 0))
        }
        sqlite3_finalize(fetchedData)
        return dataBaseName
    }
}





//ENCDEC.decryptMessage(encryptedMessage: (dataBaseName),messageType: .DataBaseName){ decryptedDataBaseName in
//    print("creating database for specific user")
//}
