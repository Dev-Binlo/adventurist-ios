//
//  StripsTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 11/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class StripsTC: UITableViewCell, UICollectionViewDelegate {
    
    static var identifier = "StripsTC"
    
    
    
    @IBOutlet weak var collectionView : UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: StripItemCC.identifier, bundle: nil), forCellWithReuseIdentifier: StripItemCC.identifier)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}

extension StripsTC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let stripCell = collectionView.dequeueReusableCell(withReuseIdentifier: StripItemCC.identifier, for: indexPath) as! StripItemCC
        
        if indexPath.row == 0{
            stripCell.bgView.backgroundColor = #colorLiteral(red: 0.4706215262, green: 0, blue: 0.7214610577, alpha: 1)
            
            stripCell.txtLabel.text = "Bookmarked"
            stripCell.txtLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            stripCell.counts.setTitle("31", for: .normal)
            stripCell.counts.setTitleColor(#colorLiteral(red: 0.4706215262, green: 0, blue: 0.7214610577, alpha: 1), for: .normal)
            stripCell.counts.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else if indexPath.row == 1{
            
            stripCell.bgView.backgroundColor = UIColor.clear
            
            stripCell.txtLabel.text = "Browsed"
            stripCell.txtLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
            stripCell.counts.setTitle("20", for: .normal)
            
            stripCell.counts.setTitle("31", for: .normal)
            stripCell.counts.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
            stripCell.counts.backgroundColor = #colorLiteral(red: 0.9693912864, green: 0.9695302844, blue: 0.969360888, alpha: 1)
            
        }else{
            stripCell.bgView.backgroundColor = UIColor.clear
            
            stripCell.txtLabel.text = "Saved"
            stripCell.txtLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
            stripCell.counts.setTitle("20", for: .normal)
            
            stripCell.counts.setTitle("31", for: .normal)
            stripCell.counts.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
            stripCell.counts.backgroundColor = #colorLiteral(red: 0.9693912864, green: 0.9695302844, blue: 0.969360888, alpha: 1)
        }
        
        
        return stripCell
    }
    

}
