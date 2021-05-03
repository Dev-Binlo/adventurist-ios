//
//  String.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 23/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var firstCapitalized: String {
        var components = self.components(separatedBy: " ")
        guard let first = components.first else {
            return self
        }
        components[0] = first.capitalized
        return components.joined(separator: " ")
    }
    
    
    


    func toDate(_ format: String = "MMM-dd-YYYY, hh:mm a") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    

}
