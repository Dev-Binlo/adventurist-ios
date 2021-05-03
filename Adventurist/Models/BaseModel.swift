//
//  BaseModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 17/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON


class BaseModel : NSObject, NSCoding{

    var status : String!
    var descriptionFeild : String!
    var data : AnyObject!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].stringValue
        descriptionFeild = json["description"].stringValue
        data = json["data"].dictionaryObject as AnyObject?
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if status != nil{
            dictionary["status"] = status
        }
        if descriptionFeild != nil{
            dictionary["description"] = descriptionFeild
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        status = aDecoder.decodeObject(forKey: "status") as? String
        descriptionFeild = aDecoder.decodeObject(forKey: "description") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if descriptionFeild != nil{
            aCoder.encode(descriptionFeild, forKey: "description")
        }

    }

}
