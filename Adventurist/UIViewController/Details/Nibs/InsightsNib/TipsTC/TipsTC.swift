//
//  TipsTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class TipsTC: UITableViewCell {
    
    static var identifier = "TipsTC"
    
    @IBOutlet weak var tips : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func ConfigureTips(detail : DetailModel){
        if let tp = detail.pictureDetail?.detail?.tips{
            if tp == "" {
                self.tips.text  = "No tips available for this picture"
            }else{
                self.tips.text  = tp
            }
        }
    }
    
    
}
