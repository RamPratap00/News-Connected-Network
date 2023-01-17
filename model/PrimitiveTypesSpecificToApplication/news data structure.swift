//
//  news data structure.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// GROBAL FILE TO REPRESENT THE NEWS STRUCTURE
import Foundation

struct Response:Codable{
    var status : String?
    var totalResults : Int?
    var articles = [Article]()
}

struct Article:Codable{
    var source = Source()
    var author : String?
    var title : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
}

struct Source:Codable{
    var id : String?
    var name : String?
}

enum SearchIn:String,Codable{
    case title
    case description
    case content
}

enum SortBy:String,Codable{
    case relevancy
    case popularity
    case publishedAt
}

let langauge = ["عربى","Deutsche","English","española","française","הברו","italiana","nederlands","Português","русский","svenska","中国人"]

enum Language:String,Codable{
    case ar = "عربى"
    case de = "Deutsche"
    case en = "English"
    case es = "española"
    case fr = "française"
    case he = "הברו"
    case it = "italiana"
    case nl = "nederlands"
    case pt = "Português"
    case ru = "русский"
    case sv = "svenska"
    case zh = "中国人"
}

