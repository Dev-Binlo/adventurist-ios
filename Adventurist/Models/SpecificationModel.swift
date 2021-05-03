//
//  SpecificationModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 22/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class SpecificationModel{

    let id: Int?
    let pictureId: Int?
    let resolution: String?
    let bitDepth: String?
    let colorRepresentation: String?
    let cameraId: Int?
    let cameraModelId: String?
    let lens: String?
    let focalStop: String?
    let focalLength: String?
    let exposureTime: String?
    let isoSpeed: String?
    let flashMode: String?
    let aperture: String?
    let subjectDistance: String?
    let createdAt: String?
    let updatedAt: String?

    init(_ json: JSON) {
        id = json["id"].intValue
        pictureId = json["picture_id"].intValue
        resolution = json["resolution"].stringValue
        bitDepth = json["bit_depth"].stringValue
        colorRepresentation = json["color_representation"].stringValue
        cameraId = json["camera_id"].intValue
        cameraModelId = json["camera_model_id"].stringValue
        lens = json["lens"].stringValue
        focalStop = json["focal_stop"].stringValue
        focalLength = json["focal_length"].stringValue
        exposureTime = json["exposure_time"].stringValue
        isoSpeed = json["iso_speed"].stringValue
        flashMode = json["flash_mode"].stringValue
        aperture = json["aperture"].stringValue
        subjectDistance = json["subject_distance"].stringValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
    }

}
