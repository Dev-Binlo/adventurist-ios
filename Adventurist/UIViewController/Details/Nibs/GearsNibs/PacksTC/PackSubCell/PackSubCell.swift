//
//  PackSubCell.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class PackSubCell: UITableViewCell {
    
    static var identifier = "PackSubCell"
    
    @IBOutlet weak var itemName : UILabel!
    @IBOutlet weak var itemImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
