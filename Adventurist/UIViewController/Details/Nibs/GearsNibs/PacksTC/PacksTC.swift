//
//  PacksTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class PacksTC: UITableViewCell {

    
    static var identifier = "PacksTC"
    
    
    
    @IBOutlet weak var tableView : UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.register(UINib(nibName: PackSubCell.identifier, bundle: nil), forCellReuseIdentifier: PackSubCell.identifier)
        tableView.tableFooterView = UIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PacksTC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PackSubCell.identifier, for: indexPath) as! PackSubCell
        cell.itemImage.image = #imageLiteral(resourceName: "28i")
        cell.itemName.text = "Tripod"
        return cell
    }
    
    
}
