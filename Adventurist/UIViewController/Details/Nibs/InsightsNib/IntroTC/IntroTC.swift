//
//  IntroTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class IntroTC: UITableViewCell {

    static var identifier = "IntroTC"
    
    
    @IBOutlet weak var fullAddress : UILabel!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var awayDistance : UILabel!
    
    @IBOutlet weak var skillLevel : LinearProgressView!
    @IBOutlet weak var accessibilityDetail : UILabel!
    @IBOutlet weak var fee : UILabel!
    @IBOutlet weak var hours : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ConfigureIntro(detail : DetailModel){
        
        if let fadd =  detail.pictureDetail?.fullAddress{
            self.fullAddress.text = fadd
        }
        
        if let cty =   detail.pictureDetail?.city, let count = detail.pictureDetail?.country{
            self.address.text = cty + ", " + count
        }
        
        if let ad =  detail.pictureDetail?.away{
            self.awayDistance.text = ad + " miles away"
        }
        
        if let sl =  detail.pictureDetail?.detail?.skillLevel{
            self.skillLevel.setProgress((sl as NSString).floatValue, animated: true)
        }
        
        if var acc =   detail.pictureDetail?.detail?.accessibility{
            acc = acc.replacingOccurrences(of: "-", with: " ")
            self.accessibilityDetail.text = acc.firstCapitalized
        }
        if let fee =   detail.pictureDetail?.detail?.fee{
            self.fee.text = fee
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"

            
        if let start =   detail.pictureDetail?.detail?.startHours, let end = detail.pictureDetail?.detail?.endHours{
            let sdate: Date?
            let edate: Date?
            if start != ""{
                sdate = dateFormatterGet.date(from: start)
            }else{
              sdate = dateFormatterGet.date(from: "00:00:00")
            }
            if end != ""{
                edate = dateFormatterGet.date(from: end)
            }else{
              edate = dateFormatterGet.date(from: "00:00:00")
            }
            
            self.hours.text = dateFormatterPrint.string(from: sdate!) + " - " + dateFormatterPrint.string(from: edate!)
        }
        
    }
    
    
}
