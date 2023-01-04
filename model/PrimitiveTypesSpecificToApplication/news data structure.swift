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

struct ArticlesWithTimeStampAndReactions{
    var article = Article()
    var timeStamp = Date()
    var positive = 0
    var negative = 0
    var neutral = 0
}

enum SortBy:String,Codable{
    case relevancy
    case popularity
    case publishedAt
}

enum Language:String,Codable{
    case ar,de,en,es,fr,he,it,nl,no,pt,ru,sv,ud,zh
}
