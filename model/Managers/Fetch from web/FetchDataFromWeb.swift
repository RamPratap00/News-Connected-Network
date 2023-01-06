//
//  FetchDataFromWeb.swift
//  News Connected Network
//
//  Created by ram-16138 on 03/01/23.
//

import Foundation


func fetchNewsThumbNail(url:URL,completionHandler:@escaping(Data)->()){
    DispatchQueue.global(qos: .userInteractive).async {
        let dataTask = URLSession.shared.dataTask(with:url){ data,response,error in
            if error == nil{
                completionHandler(data!)
            }
        }
        dataTask.resume()
    }
}
