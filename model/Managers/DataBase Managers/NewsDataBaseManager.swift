//
//  NewsDataBaseManager.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// THIS DATABASE MANAGER IS USED TO PERFORM CRUD OPERATION FOR NEWS RELATED DATA
import Foundation
import SQLite3

class NewsDataBaseManager{
    var database:DataBase
    var dataBaseName:String
    init(dataBaseName:String) {
        self.dataBaseName = dataBaseName
        self.database = DataBase(databasename: dataBaseName)
    }
    
    
    /// Creates a new table for storing news.
    /// - Parameters:
    ///   - tableName: Name of the table.
    func createTableForStoringNews(tableName:String){
        database.createTable(columnNameWithDataTypes: "ID TEXT,NAME TEXT,AUTHOR TEXT,TITLE TEXT, DESCRIPTION TEXT, URL TEXT, URLTOIMAGE TEXT, CONTENT TEXT,PUBLISHEDAT TEXT", tableName: tableName)
    }
    
    /// Inserts data into table of type news
    /// - Parameters:
    ///   - id:  Identifier.
    ///   - name: Name of the source.
    ///   - author: Name of the author.
    ///   - title: The headline or title of the article.
    ///   - description: A description or snippet from the article.
    ///   - url: The direct URL to the article.
    ///   - urlToImage: The URL to a relevant image for the article.
    ///   - content: The unformatted content of the article.
    ///   - publisherdAt: The date and time that the article was published, in UTC (+000) .
    ///   - tableName: Name of the table.
    func insertIntoTableOfTypeNews(
        id:String,
        name:String,
        author:String,
        title:String,
        description:String,
        url:String,
        urlToImage:String,
        content:String,
        publishedAt:String,
        tableName:String){
        let query = "INSERT INTO \(tableName) VALUES(?,?,?,?,?,?,?,?,?);"
        var insertStatement:OpaquePointer?
        if sqlite3_prepare_v2(database.dataBasePointer, query, -1, &insertStatement, nil) == SQLITE_OK{
            
            // name preparation
            let id:NSString = NSString(string: id)
            sqlite3_bind_text(insertStatement, 1, id.utf8String, -1, nil)
            // dob string preparation
            let name:NSString = NSString(string: name)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            
            let author:NSString = NSString(string: author)
            sqlite3_bind_text(insertStatement, 3, author.utf8String, -1, nil)
            
            let title:NSString = NSString(string: title)
            sqlite3_bind_text(insertStatement, 4, title.utf8String, -1, nil)
            
            let des:NSString = NSString(string: description)
            sqlite3_bind_text(insertStatement, 5, des.utf8String, -1, nil)
            
            let url:NSString = NSString(string: url)
            sqlite3_bind_text(insertStatement, 6, url.utf8String, -1, nil)
            
            let urltoimage:NSString = NSString(string: urlToImage)
            sqlite3_bind_text(insertStatement, 7, urltoimage.utf8String, -1, nil)
            
            let content:NSString = NSString(string: content)
            sqlite3_bind_text(insertStatement, 8, content.utf8String, -1, nil)
            
            let publishedAt:NSString = NSString(string: publishedAt)
            sqlite3_bind_text(insertStatement, 9, publishedAt.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                
            }
            else{
                print("inserion failure")
            }
        }
        else{
            print("preparation failure of insertion query")
        }
    }
    
    func closeDataBase(){
        if sqlite3_close(database.dataBasePointer) != SQLITE_OK {
            print("error closing database")
        }
    }
}
