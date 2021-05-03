//
//  HeaderVeiw.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit




class HeaderVeiw: UITableViewHeaderFooterView {

    
    static var identifier = "HeaderView"
    @IBOutlet weak var headerImage : UIImageView!
    @IBOutlet weak var segmentChange : UISegmentedControl!
    @IBOutlet weak var backButton : ButtonY!
    @IBOutlet weak var downloadButton : UIButton!
    @IBOutlet weak var shareButton : UIButton!

    
}
