//
//	UserCategory.swift
//
//	Create by Muhammad Tayyab on 3/12/2020
//	Copyright © 2020. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class UserCategory : NSObject, NSCoding{

	var id : Int!
	var name : String!

    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		id = json["id"].intValue
		name = json["name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
        let dictionary = NSMutableDictionary()
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
            aCoder.encode(id, forKey: "id")
		}
		if name != nil{
            aCoder.encode(name, forKey: "name")
		}

	}

}
