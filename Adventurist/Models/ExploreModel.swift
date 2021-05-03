//
//  ExploreModel.swift
//  Created on September 21, 2020

import Foundation
import SwiftyJSON


class ExploreModel : NSObject, NSCoding{

    var imagePrefix : String!
    var cities: [CitiesModel]?
    var filters: [FilterModel]?
    var pictures : [PictureModel]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        imagePrefix = json["image_prefix"].stringValue
        cities = [CitiesModel]()
        let citiesArray = json["cities"].arrayValue
        for citiesJson in citiesArray{
            let value = CitiesModel(fromJson: citiesJson)
            cities!.append(value)
        }
        
        filters = [FilterModel]()
        let filtersArray = json["filters"].arrayValue
        for filtersJson in filtersArray{
            let value = FilterModel(filtersJson)
            filters!.append(value)
        }
        
        pictures = [PictureModel]()
        let picturesArray = json["pictures"].arrayValue
        for picturesJson in picturesArray{
            let value = PictureModel(fromJson: picturesJson)
            pictures.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if imagePrefix != nil{
            dictionary["image_prefix"] = imagePrefix
        }
        if pictures != nil{
        var dictionaryElements = [[String:Any]]()
        for picturesElement in pictures {
            dictionaryElements.append(picturesElement.toDictionary())
        }
        dictionary["pictures"] = dictionaryElements
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        imagePrefix = aDecoder.decodeObject(forKey: "image_prefix") as? String
        pictures = aDecoder.decodeObject(forKey: "pictures") as? [PictureModel]
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if imagePrefix != nil{
            aCoder.encode(imagePrefix, forKey: "image_prefix")
        }
        if pictures != nil{
            aCoder.encode(pictures, forKey: "pictures")
        }

    }

}
