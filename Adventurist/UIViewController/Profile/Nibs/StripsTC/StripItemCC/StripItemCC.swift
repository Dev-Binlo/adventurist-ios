//
//  StripItemCC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 11/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class StripItemCC: UICollectionViewCell {
    
    static var identifier = "StripItemCC"

    @IBOutlet weak var bgView : ViewX!
    @IBOutlet weak var txtLabel : UILabel!
    @IBOutlet weak var counts : ButtonY!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
