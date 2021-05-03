//
//	UserCategoryModel.swift
//
//	Create by Muhammad Tayyab on 3/12/2020
//	Copyright © 2020. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class UserCategoryModel : NSObject, NSCoding{

    

	var userBookmarks : [UserBookmark]!
	var userCategories : [UserCategory]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		userBookmarks = [UserBookmark]()
		let userBookmarksArray = json["user_bookmarks"].arrayValue
		for userBookmarksJson in userBookmarksArray{
			let value = UserBookmark(fromJson: userBookmarksJson)
			userBookmarks.append(value)
		}
		userCategories = [UserCategory]()
		let userCategoriesArray = json["user_categories"].arrayValue
		for userCategoriesJson in userCategoriesArray{
			let value = UserCategory(fromJson: userCategoriesJson)
			userCategories.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
        let dictionary = NSMutableDictionary()
		if userBookmarks != nil{
			var dictionaryElements = [NSDictionary]()
			for userBookmarksElement in userBookmarks {
				dictionaryElements.append(userBookmarksElement.toDictionary())
			}
			dictionary["user_bookmarks"] = dictionaryElements
		}
		if userCategories != nil{
			var dictionaryElements = [NSDictionary]()
			for userCategoriesElement in userCategories {
				dictionaryElements.append(userCategoriesElement.toDictionary())
			}
			dictionary["user_categories"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        userBookmarks = aDecoder.decodeObject(forKey: "user_bookmarks") as? [UserBookmark]
        userCategories = aDecoder.decodeObject(forKey: "user_categories") as? [UserCategory]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if userBookmarks != nil{
            aCoder.encode(userBookmarks, forKey: "user_bookmarks")
		}
		if userCategories != nil{
            aCoder.encode(userCategories, forKey: "user_categories")
		}

	}

}
