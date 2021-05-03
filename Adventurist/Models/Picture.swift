//
//	Picture.swift
//
//	Create by Muhammad Tayyab on 3/12/2020
//	Copyright © 2020. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class Picture : NSObject, NSCoding{

	var away : String!
	var city : String!
	var country : String!
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
		if json == nil{
			return
		}
		away = json["away"].stringValue
		city = json["city"].stringValue
		country = json["country"].stringValue
		id = json["id"].intValue
		image = json["image"].stringValue
		lat = json["lat"].stringValue
		lng = json["lng"].stringValue
		state = json["state"].stringValue
		userId = json["user_id"].intValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
        let dictionary = NSMutableDictionary()
		if away != nil{
			dictionary["away"] = away
		}
		if city != nil{
			dictionary["city"] = city
		}
		if country != nil{
			dictionary["country"] = country
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
    @objc func encode(with aCoder: NSCoder)
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
