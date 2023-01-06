//
//  NewsAPINetworkManager.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// THIS NETWORK MANAGER IS USED TO PREPARE AND MAKE API CALLS TO https://newsapi.org/
import Foundation

class NewsAPINetworkManager{

    var pageNumber = 1
    var keyword : String? = nil
    var searchIn : SearchIn? = nil
    var language : Language? = nil
    var sortBy : SortBy? = nil
    var country:Country? = nil
    var newsCategory:NewsCategory? = nil
    var everyThingActive = false
    var headLinesActive = false
    
    
    
    /// Prepares the URL string to make the api call to https://newsapi.org/ . Refer to the newsapi documentation
    /// - Parameters:
    ///   - keyword: Keywords or phrases to search for in the article title and body..
    ///   - searchIn: The fields to restrict your keyword search to.
    ///   - language: The 2-letter ISO-639-1 code of the language you want to get headlines for.
    ///   - sortBy: The order to sort the articles in.
    /// - Returns: A URL based on the above parameter.
    func prepareURL(keyword q:String,
                    searchIn:SearchIn?,
                    language:Language?,
                    sortBy:SortBy?)->URL?{
        var urlString = "https://newsapi.org/v2/everything?"
        let apiKey = "&apiKey=8fa02b5718244406a73b413d03f0ecbe"
        urlString.append("q=\(q)")
        if let searchIn = searchIn{ urlString.append("&searchIn=\(searchIn.rawValue)") }
        if let language = language{ urlString.append("&language=\(language.rawValue)") }
        if let sortBy = sortBy{ urlString.append("&sortBy=\(sortBy.rawValue)") }
        
        
        urlString.append("&pageSize=10")
        urlString.append("&page=\(pageNumber)")
        urlString.append(apiKey)
        return URL(string: urlString)
    }
    
    /// Creates a HTTPS session to fetch data from https://newsapi.org/ using prepareURL(...).
    /// - Parameters:
    ///   - keyword: Keywords or phrases to search for in the article title and body..
    ///   - searchIn: The fields to restrict your keyword search to.
    ///   - language: The 2-letter ISO-639-1 code of the language you want to get headlines for.
    ///   - sortBy: The order to sort the articles in.
    ///   - completionHandler: call back when the task is complete.
    func session(keyword:String,
                 searchIn:SearchIn?,
                 language:Language?,
                 sortBy:SortBy?,
                 completionHandler: @escaping (Response?,Error?)->()){
        self.keyword = keyword
        self.searchIn = searchIn
        self.language = language
        self.sortBy = sortBy
        
        guard let url = prepareURL(keyword: keyword,searchIn: searchIn,language:language,sortBy:sortBy) else{
            print(" URL peparation failed ! ")
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
    
    
    func sessionToLoadHeadLines(keyword q:String?,
                                country:Country?,
                                newsCategory:NewsCategory?,
                                completionHandler: @escaping (Response?,Error?)->()){
        self.keyword = q
        self.country = country
        self.newsCategory = newsCategory
        
        var urlString = "https://newsapi.org/v2/top-headlines?"
        let apiKey = "&apiKey=8fa02b5718244406a73b413d03f0ecbe"
        if let q = q{
            urlString.append("q=\(q)")
            if let country = country{ urlString.append("&country=\(country.rawValue)")}
            if let newsCategory = newsCategory{urlString.append("&category=\(newsCategory.rawValue)") }
        }
        else{
            if let country = country{
                urlString.append("country=\(country.rawValue)")
                if let newsCategory = newsCategory{urlString.append("&category=\(newsCategory.rawValue)") }
            }
            else{
                if let newsCategory = newsCategory{urlString.append("category=\(newsCategory.rawValue)") }
            }
        }
        
        urlString.append(apiKey)
        
        guard let url = URL(string: urlString) else{
            print(" URL peparation failed ! ")
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
    
    
    
    func fetchMore(completionHandler: @escaping (Response?,Error?)->()){
        pageNumber = pageNumber + 1
        if headLinesActive{
            sessionToLoadHeadLines(keyword: keyword, country: country, newsCategory: newsCategory){ moreData,error  in
                
                if error == nil && moreData?.articles != nil{
                    completionHandler(moreData!, nil)
                }
                else{
                    completionHandler(nil,error)
                }
                
            }
        }
        else{
            session(keyword: keyword!, searchIn: searchIn, language: language, sortBy: sortBy){ moreData,error  in
                
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


enum Country:String{
    case ae
    case ar
    case at
    case au
    case be
    case bg
    case br
    case ca
    case ch
    case cn
    case co
    case cu
    case cz
    case de
    case eg
    case fr
    case gb
    case gr
    case hk
    case hu
    case id
    case ie
    case il
    case In = "in"
    case it
    case jp
    case kr
    case lt
    case lv
    case ma
    case mx
    case my
    case ng
    case nl
    case no
    case nz,ph,pl,pt,ro,rs,ru,sa,se,sg,si,sk,th,tr,tw,ua,us,ve,za
}

enum NewsCategory:String{
    case business,entertainment,general,health,science,sports,technology
}
