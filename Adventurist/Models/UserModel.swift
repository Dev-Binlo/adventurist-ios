//
//  User.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 16/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON


class UserModel : NSObject, NSCoding{

    var email : String?
    var firstName : String?
    var fullName : String?
    var lastName : String?
    var dob : String?
    var gender : String?
    var status : Int?

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        fullName = json["full_name"].stringValue
        lastName = json["last_name"].stringValue
        dob = json["dob"].stringValue
        gender = json["gender"].stringValue
        status = json["status"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if email != nil{
            dictionary["email"] = email
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if dob != nil{
            dictionary["dob"] = lastName
        }
        if gender != nil{
            dictionary["gender"] = lastName
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        email = aDecoder.decodeObject(forKey: "email") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as?  String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "full_name")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if dob != nil{
            aCoder.encode(lastName, forKey: "dob")
        }
        if gender != nil{
            aCoder.encode(lastName, forKey: "gender")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

    }

}
