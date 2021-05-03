//
//  PictureModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 21/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class PictureModel : NSObject, NSCoding{

    var categoryId : String!
    var city : String!
    var country : String!
    var createdAt : String!
    var fullAddress : String!
    var id : Int!
    var image : String!
    var imageDate : String!
    var lat : String!
    var lng : String!
    var plotNo : String!
    var state : String!
    var status : Int!
    var streetAddress : String!
    var updatedAt : String!
    var userId : Int!
    var zip : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["category_id"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        createdAt = json["created_at"].stringValue
        fullAddress = json["full_address"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        imageDate = json["image_date"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        plotNo = json["plot_no"].stringValue
        state = json["state"].stringValue
        status = json["status"].intValue
        streetAddress = json["street_address"].stringValue
        updatedAt = json["updated_at"].stringValue
        userId = json["user_id"].intValue
        zip = json["zip"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if city != nil{
            dictionary["city"] = city
        }
        if country != nil{
            dictionary["country"] = country
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if fullAddress != nil{
            dictionary["full_address"] = fullAddress
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if imageDate != nil{
            dictionary["image_date"] = imageDate
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        if plotNo != nil{
            dictionary["plot_no"] = plotNo
        }
        if state != nil{
            dictionary["state"] = state
        }
        if status != nil{
            dictionary["status"] = status
        }
        if streetAddress != nil{
            dictionary["street_address"] = streetAddress
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if zip != nil{
            dictionary["zip"] = zip
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        fullAddress = aDecoder.decodeObject(forKey: "full_address") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? String
        imageDate = aDecoder.decodeObject(forKey: "image_date") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        plotNo = aDecoder.decodeObject(forKey: "plot_no") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Int
        streetAddress = aDecoder.decodeObject(forKey: "street_address") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
        zip = aDecoder.decodeObject(forKey: "zip") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if fullAddress != nil{
            aCoder.encode(fullAddress, forKey: "full_address")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if imageDate != nil{
            aCoder.encode(imageDate, forKey: "image_date")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        if plotNo != nil{
            aCoder.encode(plotNo, forKey: "plot_no")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if streetAddress != nil{
            aCoder.encode(streetAddress, forKey: "street_address")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if zip != nil{
            aCoder.encode(zip, forKey: "zip")
        }

    }

}
