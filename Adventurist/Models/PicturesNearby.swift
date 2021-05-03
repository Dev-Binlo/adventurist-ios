//
//  PicturesNearby.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 30/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON


class PicturesNearby : NSObject, NSCoding{

    var away : String!
    var city : String!
    var country : String!
    var distance : Float!
    var id : Int!
    var image : String!
    var lat : String!
    var lng : String!
    var state : String!
    var userId : Int!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        away = json["away"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        distance = json["distance"].floatValue
        id = json["id"].intValue
        image = json["image"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        state = json["state"].stringValue
        userId = json["user_id"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if away != nil{
            dictionary["away"] = away
        }
        if city != nil{
            dictionary["city"] = city
        }
        if country != nil{
            dictionary["country"] = country
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        if state != nil{
            dictionary["state"] = state
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        away = aDecoder.decodeObject(forKey: "away") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? Float
        id = aDecoder.decodeObject(forKey: "id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if away != nil{
            aCoder.encode(away, forKey: "away")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }

    }

}
