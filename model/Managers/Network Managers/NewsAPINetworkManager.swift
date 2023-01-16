//
//  NewsAPINetworkManager.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// THIS NETWORK MANAGER IS USED TO PREPARE AND MAKE API CALLS TO https://newsapi.org/
import Foundation

let apiKey = "8fa02b5718244406a73b413d03f0ecbe"
//let apiKey = "327d15296670458bb67a34d9bc4648d6"

class NewsAPINetworkManager{

    private var pageNumber = 0
    private var keyword : String? = nil
    private var searchIn : SearchIn? = nil
    private var language : String? = currentUserAccountObject().language
    private var sortBy : SortBy? = nil
    internal var newsCategory:NewsCategory? = nil
    private var everyThingActive = false
    internal var headLinesActive = false
    
    
    
    /// Prepares the URL string to make the api call to https://newsapi.org/ . Refer to the newsapi documentation
    /// - Parameters:
    ///   - keyword: Keywords or phrases to search for in the article title and body..
    ///   - searchIn: The fields to restrict your keyword search to.
    ///   - language: The 2-letter ISO-639-1 code of the language you want to get headlines for.
    ///   - sortBy: The order to sort the articles in.
    /// - Returns: A URL based on the above parameter.
    private func prepareURL(keyword q:String,
                    searchIn:SearchIn?,
                    language:String?,
                    sortBy:SortBy?)->URL?{
        var urlString = "https://newsapi.org/v2/everything?"
        let apiKey = "&apiKey=\(apiKey)"
        urlString.append("q=\(q)")
        if let searchIn = searchIn{ urlString.append("&searchIn=\(searchIn.rawValue)") }
        if let language = language{ urlString.append("&language=\(languageKey(lang: language))") }
        if let sortBy = sortBy{ urlString.append("&sortBy=\(sortBy.rawValue)") }
        
        
        urlString.append("&pageSize=10")
        urlString.append("&page=\(pageNumber)")
        urlString.append(apiKey)
        //print(urlString)
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedString) else {
              print("Url Preparation Failure")
            return nil
        }
        return url
    }
    
    /// Creates a HTTPS session to fetch data from https://newsapi.org/ using prepareURL(...).
    /// - Parameters:
    ///   - keyword: Keywords or phrases to search for in the article title and body..
    ///   - searchIn: The fields to restrict your keyword search to.
    ///   - language: The 2-letter ISO-639-1 code of the language you want to get headlines for.
    ///   - sortBy: The order to sort the articles in.
    ///   - completionHandler: call back when the task is complete.
    internal func session(keyword:String,
                 searchIn:SearchIn?,
                 language:String?,
                 sortBy:SortBy?,
                 completionHandler: @escaping (Response?,Error?)->()){
        self.keyword = keyword
        self.searchIn = searchIn
        self.language = language
        self.sortBy = sortBy
        
        guard let url = prepareURL(keyword: keyword,searchIn: searchIn,language:language,sortBy:sortBy) else{
            print(" URL peparation failed ! ")
            completionHandler(nil,nil)
            return
        }
        everyThingActive = true
        headLinesActive = false
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
                    
                    if error != nil || data == nil {
                        print("Client error!")
                        completionHandler(nil, error)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        print("Server error!")
                        completionHandler(nil,error)
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(Response.self, from: data!)
                        completionHandler(results,nil)
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                    
                }
                task.resume()
    }
    
    internal func sessionToLoadHeadLines(keyword q:String?,
                                newsCategory:NewsCategory?,
                                language:String?,
                                completionHandler: @escaping (Response?,Error?)->()){
        everyThingActive = false
        headLinesActive = true
        
        self.keyword = q
        self.newsCategory = newsCategory
        self.language = language
        
        var urlString = "https://newsapi.org/v2/top-headlines?"
        let apiKey = "&apiKey=\(apiKey)"
        if let q = q{
            urlString.append("q=\(q)")
            if let newsCategory = newsCategory{urlString.append("&category=\(newsCategory.rawValue)") }
        }
        else{
            if let newsCategory = newsCategory{urlString.append("category=\(newsCategory.rawValue)") }
        }
        if urlString == "https://newsapi.org/v2/top-headlines?"{
            if let language = language{urlString.append("language=\(languageKey(lang: language))")}
        }
        else{
            if let language = language{urlString.append("&language=\(languageKey(lang: language))")}
        }
        urlString.append("&pageSize=10")
        urlString.append("&page=\(pageNumber)")
        urlString.append(apiKey)
        //print(urlString)
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedString) else {
            print("Url Preparation Failure")
            completionHandler(nil,nil)
            return
        }
        everyThingActive = false
        headLinesActive = true
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
                    
                    if error != nil || data == nil {
                        print("Client error!")
                        completionHandler(nil, error)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        print("Server error!")
                        completionHandler(nil,error)
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(Response.self, from: data!)
                        completionHandler(results,nil)
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                    
                }
                task.resume()
    }
    
    
    internal func fetchMore(completionHandler: @escaping (Response?,Error?)->()){
        pageNumber = pageNumber + 1
        if headLinesActive{
            sessionToLoadHeadLines(keyword: keyword, newsCategory: newsCategory, language: language){ moreData,error  in
                
                if error == nil && moreData?.articles != nil{
                    completionHandler(moreData!, nil)
                }
                else{
                    completionHandler(nil,error)
                }
                
            }
        }
        else{
            if hasNetworkConnection(){
                guard let keyword = keyword else{ return}
                session(keyword: keyword, searchIn: searchIn, language: language, sortBy: sortBy){ moreData,error  in
                    
                    if error == nil && moreData?.articles != nil{
                        completionHandler(moreData!, nil)
                    }
                    else{
                        completionHandler(nil,error)
                    }
                    
                }
            }
        }
    }
    
    
}


enum NewsCategory:String{
    case business,entertainment,general,health,science,sports,technology
}
