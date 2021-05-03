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
    
    
    
    var imagetoUpload: UIImage? = nil
    /*** Category */
    var category : String? = ""
    
    /*** Location */
    var address : String? = ""
    
    /*** Additional */
    var skillLevel : String? = ""
    var accessibility : String? = ""
    var fee : String? = ""
    var startTime : String? = ""
    var endTime : String? = ""
    var tips : String? = ""
    
    
    /**
     Specifications
     */
    
    var camera : String? = ""
    var model : String? = ""
    var lens : String? = ""
    var focalStop : String? = ""
    var focalLength : String? = ""
    var resolution : String? = ""
    var bitDepth : String? = ""
    var colorRepresentation : String? = ""
    var explosureTime : String? = ""
    var ISOSpeed : String? = ""
    var flashMode : String? = ""
    var aperture : String? = ""
    var subjectDistance : String? = ""
    
    
}
