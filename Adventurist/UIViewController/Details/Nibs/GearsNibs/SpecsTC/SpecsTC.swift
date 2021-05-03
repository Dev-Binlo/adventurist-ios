//
//  SpecsTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class SpecsTC: UITableViewCell {

    
    static var identifier = "SpecsTC"
    
    
    
    @IBOutlet weak var lens : UILabel!
    @IBOutlet weak var exposureTime : UILabel!
    
    @IBOutlet weak var iso : UILabel!
    @IBOutlet weak var focalStop : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ConfigureSpecs(detail : DetailModel){
        
        if let ln = detail.pictureDetail?.specifications?.lens{
            self.lens.text  = ln
        }
        if let et = detail.pictureDetail?.specifications?.exposureTime{
            self.exposureTime.text  = et
        }
        
        if let iso = detail.pictureDetail?.specifications?.isoSpeed{
            self.iso.text  = iso
        }
        
        if let fs = detail.pictureDetail?.specifications?.focalStop{
            self.focalStop.text  = fs
        }
        
        
    }
    
    
}
