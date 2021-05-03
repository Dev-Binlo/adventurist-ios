//
//  DetailedModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 22/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubDetailedModel {

    let id: Int?
    let pictureId: Int?
    let skillLevel: String?
    let accessibility: String?
    let startHours: String?
    let endHours: String?
    let fee: String?
    let tips: String?
    let createdAt: String?
    let updatedAt: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        pictureId = json["picture_id"].intValue
        skillLevel = json["skill_level"].stringValue
        accessibility = json["accessibility"].stringValue
        startHours = json["start_hours"].stringValue
        endHours = json["end_hours"].stringValue
        fee = json["fee"].stringValue
        tips = json["tips"].stringValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

}
