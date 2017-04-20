//
//  Analytics.swift
//  BullsEye
//
//  Created by MouseHouseApp on 4/19/17.
//  Copyright © 2017 Umar Khokhar. All rights reserved.
//

import Foundation


class Analytics {
    
    
    // -MARK: Shared Instance
    static let shared = Analytics()
    private init() {}
    
    
    // Create the url with URL
    let url = URL(string: "http://localhost:8080/")!
    
    //User defaults
    let defaults = UserDefaults.standard
    
    // Create the session object
    let session = URLSession.shared
    
    var data = [
        "session" : [
            "user"  : "some_unique_identifier",
            "start" : "Apr 11, 2017, 6:17 PM",
            "end"   : "Apr 13, 2017, 6:19 PM",
            "events" : [
                [ "id" : "share-button" ],
                [ "id" : "home-button"  ],
                [ "id" : "info-button" ],
                [ "id" : "navigate-home" ],
                [ "id" : "navigate-home" ]
            ],
            "touches": [
                ["x": 10.5,"y" : 0],
                ["x": 20.1,"y" : 20],
                ["x": 30.2,"y" : 11],
                ["x": 110.6,"y" : 311],
                ["x": 0.2,"y" : 1],
                ["x": 310.9,"y" : 2]
            ]
        ]
    ]
    
    
    // -MARK: Data tracked
    var user : String = "user"
    var start : Date = Date()
    var end : Date = Date()
    var events : [[String : String]] = [["id": "nothing"]]
    var touches : [[String : Double]] = [["x": 0, "y": 0]]
    
    
    func addTouch(x: Double, y: Double){
        let dict = ["x" : x, "y" : y]
        touches.append(dict)
    }
    
    func addEvent(event : String){
        let dict = ["id" : event]
        events.append(dict)
    }
    
    func setStart(date : Date){
        start = date
    }
    
    func setEnd(date : Date){
        end = date
    }
    
    
    // -MARK: Process data
    
    func sendData(){
        
        // Create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        // Set http method as POST and add headers
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Convert the data to JSON
        do {
            data = transformData() as! [String : Dictionary<String, Any>]
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            print(error.localizedDescription)
        }
        
        print(request)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest,
                                    completionHandler: { data, response, error in
                                        // This is what should be returned by the server
                                        print(response ?? "No response")
                                        print(data ?? "No Data")
        })
        task.resume()
    }
    
    func transformData() -> [String : Any]{
        var data : [String : Any] = [:]
        
        let startDate = start.description
        let endDate = end.description
        
        data = ["session" : ["user" : user, "start" : startDate, "end" : endDate, "events": events, "touches" : touches]]
        
        print(data)
        
        return data
    }
    
}
