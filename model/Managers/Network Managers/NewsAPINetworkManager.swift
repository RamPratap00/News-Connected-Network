//
//  NewsAPINetworkManager.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// THIS NETWORK MANAGER IS USED TO PREPARE AND MAKE API CALLS TO https://newsapi.org/
import Foundation

class NewsAPINetworkManager{

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
        guard let url = prepareURL(keyword: keyword,searchIn: searchIn,language:language,sortBy:sortBy) else{
            print(" URL peparation failed ! ")
            return
        }
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
    
}
