//
//  CitiesModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 22/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class CitiesModel : NSObject, NSCoding{
    
    var id : Int!
    var city: String!
    var cityCount: Int!
    var lat: String!
    var lng: String!
    
    init (fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        city = json["city"].stringValue
        cityCount = json["city_count"].intValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
    }
    
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        
        if id != nil{
            dictionary["id"] = id
        }
        if city != nil{
            dictionary["city"] = city
        }
        if cityCount != nil{
            dictionary["city_count"] = cityCount
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        return dictionary
    }

    @objc required init(coder aDecoder: NSCoder){
        id = aDecoder.decodeObject(forKey: "id") as? Int
        city = aDecoder.decodeObject(forKey: "city") as? String
        cityCount = aDecoder.decodeObject(forKey: "city_count") as? Int
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        
    }
    
    func encode(with aCoder: NSCoder){
        if id != nil{
            aCoder.encode(city, forKey: "id")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if cityCount != nil{
            aCoder.encode(cityCount, forKey: "city_count")
        }
        if lat != nil{
            aCoder.encode(city, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(city, forKey: "lng")
        }
        
    }
}
