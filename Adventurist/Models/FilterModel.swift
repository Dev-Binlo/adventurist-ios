//
//  FilterModel.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 22/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class FilterModel{

    var id: Int!
    var name: String!

    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }

}
