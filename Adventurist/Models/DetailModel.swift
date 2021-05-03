//
//  DetailModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 22/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class DetailModel {

    let imagePrefix: String?
    var pictureDetail: PictureDetailModel?
    var picturesNearby : [PicturesNearby]?

    init(_ json: JSON) {
        imagePrefix = json["image_prefix"].stringValue
        pictureDetail = PictureDetailModel(json["picture_detail"])
        picturesNearby = [PicturesNearby]()
        let picturesArray = json["pictures_nearby"].arrayValue
        for picturesJson in picturesArray{
            let value = PicturesNearby(fromJson: picturesJson)
            picturesNearby!.append(value)
        }
    }

}
