//
//  MapNetworkManager.swift
//  MapSearch
//
//  Created by Galit Ronen on 10/29/18.
//  Copyright © 2018 Consult Partners US. All rights reserved.
//

import UIKit

// Mark: - Protocols
protocol MapNetworkManagerDelegate {
    func didFinishDownloading()
}

class MapNetworkManager: NSObject, MapURLRequestDelegate {
    
    // Mark: - URI's
    struct remoteURI {
        let domain  = "https://maps.googleapis.com"
        let apiPath  = "/maps/api/place"
        let apiVersion = "" // Future versions of the API may have /v2 for example
        let apiKey     = "AIzaSyA4tb9ueZXPYQmZ5821DPbNy2FDHOlWDls"
        let apiFormat  = "json"
        
        func autoComplete() -> String {
            return "\(domain)\(apiPath)\(apiVersion)/queryautocomplete/\(apiFormat)?key=\(apiKey)"
        }
        
        func autoCompleteQuery(input:String, location:String) -> String {
            return "&input=\(input)&location=\(location)&radius=10"
        }
    }
    
    // Mark: - Class Variables
    
    var delegate : MapNetworkManagerDelegate?
    var predictionArray = Array<String>()
    let rURI = remoteURI()
    
    // Mark: - Functions
    
    func getAutoCompletePredictions(input:String) {
        let request = MapURLRequest()
        request.delegate = self
        request.startRequest(uri: rURI.autoComplete(), querystring: rURI.autoCompleteQuery(input: input, location: self.currentLocation()))
    }
    
    func clearValues() {
        predictionArray.removeAll()
    }
    
    func currentLocation() -> String {
        //let locationManager = CLLocationManager()
        return "40.766363,-73.977882"
    }
    
    func didLoadResponse(response:[String: Any]) {
        self.parseResponse(response)
    }
    
    func parseResponse(_ dictionary:[String: Any]) {

        guard let predictions = dictionary["predictions"] as? [Any] else {
            print("Parsing API Result failed. Tried to access predictions key of the dictionary which didn't exist as expected.")
            return
        }
        predictionArray.removeAll()
        
        for prediction in predictions {
            guard let prediction = prediction as? [String: Any] else {
                print ("Error reading the prediction item as a dictionary of values")
                return
            }
            guard let predictedText = prediction["description"] as? String else {
                print("Error retrieving the text description of the prediction item in the prediction array.")
                return
            }
            predictionArray.append(predictedText)  // Save the predicted text value into our array
        }
        
        guard let delegate = delegate else {
            print("Delegate is empty")
            return
        }
        
        delegate.didFinishDownloading()  // Notify the delegate, the array is ready to be used
    }
    
}
