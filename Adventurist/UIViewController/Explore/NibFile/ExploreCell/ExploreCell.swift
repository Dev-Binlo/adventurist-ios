//
//  ExploreCell.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 09/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class ExploreCell: UITableViewCell {
    
    static var identifier = "ExploreCell"
    
    
    @IBOutlet weak var img : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
