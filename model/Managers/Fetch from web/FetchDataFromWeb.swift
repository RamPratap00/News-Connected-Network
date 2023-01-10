//
//  FetchDataFromWeb.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import Foundation


func fetchNewsThumbNail(url:URL,completionHandler:@escaping(Data?,Error?)->()){
    DispatchQueue.global(qos: .userInteractive).async {
        let dataTask = URLSession.shared.dataTask(with:url){ data,response,error in
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error! error fetching image")
                completionHandler(nil,error)
                return
            }
            
            if error == nil && data != nil{
                completionHandler(data!, nil)
            }
        }
        dataTask.resume()
    }
}
