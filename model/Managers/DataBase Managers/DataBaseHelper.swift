//
//  DataBaseHelper.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// THIS DATABASE MANAGER IS USED AS A HELPER TO ABSTRACT BASIC SQL COMMANDS
import Foundation
import SQLite3

class DataBase{
    
    var dataBasePointer:OpaquePointer?
    var tableList = [String]()
    
    init(databasename:String) {
        self.dataBasePointer = createOrOpenDataBase(dataBaseName: databasename)
    }
    
    /// Prints list of all atble available in the database.
    func printTableList(){
        print(tableList)
    }
    
    // MARK: - CREATE
    
    ///  Creates/open a new data base.
    /// - Parameters:
    ///   - dataBaseName: Name of the new database.
    /// - Returns: An OpaquePointer? pointing to the database.
    func createOrOpenDataBase(dataBaseName:String)->OpaquePointer?{
        var pointer : OpaquePointer?
        
        let filepath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(dataBaseName)

        if sqlite3_open(filepath.path(), &pointer) == SQLITE_OK{
            print("data base created/opend successfully..")
        }
        else{
            print("data base creation/open failure..")
        }
        
        return pointer
        
    }
    
    
    
    /// Creates a new table.
    /// - Parameters:
    ///   - columnNameWithDataTypes: Name of the column with its type eg: ID TEXT,NAME TEXT.
    ///   - tableName: Name of the table.
    func createTable(columnNameWithDataTypes:String,tableName:String){
        let query = "CREATE TABLE IF NOT EXISTS \(tableName)(\(columnNameWithDataTypes));"
        var tablePointer : OpaquePointer?
        
        if sqlite3_prepare_v2(dataBasePointer, query, -1, &tablePointer, nil) == SQLITE_OK{
            if sqlite3_step(tablePointer) == SQLITE_DONE{
                print("table created")
                tableList.append(tableName)
            }
            else{
                print("creation failure")
            }
        }
        else{
            print("preparation failure")
        }
        sqlite3_finalize(tablePointer)
        
    }
    
    // MARK: - READ
    
    /// Reads all the rows of the table.
    /// - Parameters:
    ///   - tableName: Name of the table.
    /// - Returns: An OpaquePointer? pointing to the table fetched by the query.
    func readFullTable(tableName:String)->OpaquePointer?{
        let query = "SELECT * FROM \(tableName);"
        var selectStatement:OpaquePointer?
        guard sqlite3_prepare_v2(dataBasePointer, query, -1, &selectStatement, nil) != SQLITE_OK else{

            return selectStatement
        }
        return selectStatement
    }
    
    /// Reads specific rows of the table based on the constrain.
    /// - Parameters:
    ///   - query: sqlite query.
    /// - Returns: An OpaquePointer? pointing to the table fetched by the query.
    func readWithConstrains(query:String)->OpaquePointer?{
        var selectStatement:OpaquePointer?
        if sqlite3_prepare_v2(dataBasePointer, query, -1, &selectStatement, nil) != SQLITE_OK{
            return selectStatement

        }
        return selectStatement
    }
    
    // MARK: - UPDATE
    
    // table type specific
    
    // MARK: - DELETE
    ///  Delete the entire table.
    /// - Parameters:
    ///   - tableName: Name of the table to be deleted
    func dropTable(tableName:String){
        let query = "DROP TABLE \(tableName)"
        var dropStatement:OpaquePointer?
        if sqlite3_prepare_v2(dataBasePointer, query, -1, &dropStatement, nil) == SQLITE_OK{
            if sqlite3_step(dropStatement) == SQLITE_DONE{
                print("table: \(tableName) dropped")
            }
            sqlite3_finalize(dropStatement)
        }
        
    }
    
}

