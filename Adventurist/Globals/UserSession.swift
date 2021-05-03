//
//  UserSession.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 17/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class UserSession{
    static var loginSession : LoginModel? = nil
    static var keyLoginSession = "userLoginKey"
    static var lat : CLLocationDegrees? = 22.3193
    static var lng : CLLocationDegrees? = 114.169
    static var generalFilters : [FilterModel] = []
    
}

class UploadSession {
    
    
    
    static var imagetoUpload: UIImage? = nil
    /*** Category */
    static var category : [String]? = []

    /*** Location */
    static var address : String? = ""
    static var fullAddress : String? = ""
    static var plot_no : String? = ""
    static var street_address : String? = ""
    static var city : String? = ""
    static var state : String? = ""
    static var country : String? = ""
    static var zip : String? = ""
    static var lat : String? = ""
    static var lng : String? = ""

    /*** Accessibility */
    static var  skillLevel: String? = ""
    static var accessibility: String? = ""
    static var fee: String? = ""
    static var startHours: String? = ""
    static var endHours: String? = ""
    static var tips: String? = ""
    
    
    /**
     Specifications
     */
    static var cameraId : String? = "19"
    static var cameraModelId : String? = ""
    static var cameraType: String? = ""
    static var lens : String? = ""
    static var focalStop : String? = ""
    static var focalLength : String? = ""
    static var resolution : String? = ""
    static var bitDepth : String? = ""
    static var colorRepresentation : String? = ""
    static var exposureTime : String? = ""
    static var shutter : String? = ""
    static var isoSpeed : String? = ""
    static var temprature : String? = ""
    static var aperture : String? = ""
    static var flashMode : String? = ""
    static var subjectDistance : String? = ""
    
    
    
}
