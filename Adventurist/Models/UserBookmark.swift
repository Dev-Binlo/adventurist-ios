//
//	UserBookmark.swift
//
//	Create by Muhammad Tayyab on 3/12/2020
//	Copyright © 2020. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class UserBookmark : NSObject, NSCoding{

	var createdAt : String!
	var id : Int!
	var name : String!
	var pictures : [Picture]!
	var slug : String!
	var status : Int!
	var type : String!
	var updatedAt : String!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		createdAt = json["created_at"].stringValue
		id = json["id"].intValue
		name = json["name"].stringValue
		pictures = [Picture]()
		let picturesArray = json["pictures"].arrayValue
		for picturesJson in picturesArray{
			let value = Picture(fromJson: picturesJson)
			pictures.append(value)
		}
		slug = json["slug"].stringValue
		status = json["status"].intValue
		type = json["type"].stringValue
		updatedAt = json["updated_at"].stringValue
		userId = json["user_id"].intValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
        let dictionary = NSMutableDictionary()
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if pictures != nil{
			var dictionaryElements = [NSDictionary]()
			for picturesElement in pictures {
				dictionaryElements.append(picturesElement.toDictionary())
			}
			dictionary["pictures"] = dictionaryElements
		}
		if slug != nil{
			dictionary["slug"] = slug
		}
		if status != nil{
			dictionary["status"] = status
		}
		if type != nil{
			dictionary["type"] = type
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
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
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        pictures = aDecoder.decodeObject(forKey: "pictures") as? [Picture]
        slug = aDecoder.decodeObject(forKey: "slug") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
		}
		if id != nil{
            aCoder.encode(id, forKey: "id")
		}
		if name != nil{
            aCoder.encode(name, forKey: "name")
		}
		if pictures != nil{
            aCoder.encode(pictures, forKey: "pictures")
		}
		if slug != nil{
            aCoder.encode(slug, forKey: "slug")
		}
		if status != nil{
            aCoder.encode(status, forKey: "status")
		}
		if type != nil{
            aCoder.encode(type, forKey: "type")
		}
		if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
		}

	}

}
