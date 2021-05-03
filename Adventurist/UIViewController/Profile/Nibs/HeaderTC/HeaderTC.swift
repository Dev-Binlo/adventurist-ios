//
//  HeaderTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 11/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class HeaderTC: UITableViewCell {

    
    static var identifier = "HeaderTC"
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var settingsBtn : UIButton!
    @IBOutlet weak var followersCount : UILabel!
    @IBOutlet weak var followingCount : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureHeader(){
        self.nameLabel.text = UserSession.loginSession!.user!.firstName! + " " + UserSession.loginSession!.user!.lastName!
        self.followersCount.text = "251"
        self.followingCount.text = "360"
    }
    
    
}
