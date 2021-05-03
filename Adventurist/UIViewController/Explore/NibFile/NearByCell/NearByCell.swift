//
//  CollectionViewCell.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 09/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class NearByCell: UICollectionViewCell {
    
    static var identifier = "NearByCell"
    
    
    @IBOutlet weak var nearbyLabel : UILabel!
    @IBOutlet weak var bg : ViewX!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
