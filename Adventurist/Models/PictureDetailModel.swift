//
//  PictureDetailModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 22/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//
import Foundation
import SwiftyJSON

class PictureDetailModel {

    var id: Int?
    var image: String?
    var userId: Int?
    var categoryId: Any?
    var plotNo: Any?
    var streetAddress: Any?
    var city: String?
    var state: String?
    var country: String?
    var zip: Any?
    var fullAddress: String?
    var lat: String?
    var lng: String?
    var imageDate: String?
    var status: Int?
    var createdAt: String?
    var updatedAt: String?
    var away : String?
    var detail: SubDetailedModel?
    var specifications: SpecificationModel?
    var categories: [FilterModel]?

    init(_ json: JSON) {
        id = json["id"].intValue
        image = json["image"].stringValue
        userId = json["user_id"].intValue
        categoryId = json["category_id"]
        plotNo = json["plot_no"]
        streetAddress = json["street_address"]
        city = json["city"].stringValue
        state = json["state"].stringValue
        country = json["country"].stringValue
        zip = json["zip"]
        fullAddress = json["full_address"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        imageDate = json["image_date"].stringValue
        status = json["status"].intValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
        away = json["away"].stringValue
        detail = SubDetailedModel(json["detail"])
        specifications = SpecificationModel(json["specifications"])
        categories = json["categories"].arrayValue.map { FilterModel($0) }
        
        
        
        
//        picturesNearby = json["pictures_nearby"].arrayValue.map { PicturesNearby(fromJson: $0) }
    }

}
