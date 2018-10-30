//
//  MapURLRequest.swift
//  MapSearch
//
//  Created by Galit Ronen on 10/29/18.
//  Copyright © 2018 Consult Partners US. All rights reserved.
//

import UIKit

protocol MapURLRequestDelegate {
    func didLoadResponse(response:[String: Any])
}

class MapURLRequest {

    var delegate : MapURLRequestDelegate?

    func startRequest(uri:String, querystring:String) {
        let session = URLSession(configuration: .default)
        let percentEncodedQueryString = querystring.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        guard let encodedQueryString = percentEncodedQueryString else {
            print("Error encoding input into the URL query string")
            return
        }
        
        guard let url = URL(string: uri + encodedQueryString) else {
            print("Invalid URL from \(uri).")
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("URL Request returned an error: \(String(describing: error)).")
                return
            }
            
            guard let data = data else {
                print("No data was returned from the url request.")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Invalid JSON returned from the url request.")
                    return
                }
                guard let delegate = self.delegate else {
                    print("Delegate was empty")
                    return
                }
                delegate.didLoadResponse(response: json)  // Notify the delegate that response is ready
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        dataTask.resume()
    }
}
