//
//  GalleryTCTableViewCell.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 11/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit


class GalleryTC: UITableViewCell{
    
    static var identifier = "GalleryTC"
    var imageBaseURL : String? = nil
    var userBookMarkImages : UserBookmark? = nil
    
    @IBOutlet weak var galleryCV : UICollectionView!
    @IBOutlet weak var galleryTitle : UILabel!
    @IBOutlet weak var galleryTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
    
        galleryCV.register(UINib(nibName: GalleryCC.identifier, bundle: nil), forCellWithReuseIdentifier: GalleryCC.identifier)
        
        if #available(iOS 13.0, *) {
            galleryCV.collectionViewLayout = CustomCollectionViewLayouts.MosaicLayout(isLandscape: true, scrollDirection: .horizontal, size: self.contentView.bounds.size)
            
            galleryCV.collectionViewLayout = CustomCollectionViewLayouts.MosaicReduxLayout()
            galleryCV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
            // Fallback on earlier versions
        }
    }
    
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func moreAction(_ sender: UIButton){
        print("moreAction....");
    }
    
}



extension GalleryTC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(userBookMarkImages != nil){
            if userBookMarkImages!.pictures.count > 0 {
                return self.userBookMarkImages!.pictures.count
            }
            else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userBookMarkImages!.pictures.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryCell = galleryCV.dequeueReusableCell(withReuseIdentifier: GalleryCC.identifier, for: indexPath) as! GalleryCC
        galleryCell.galleryImg.kf.setImage(with: URL(string: "https://dev.foodofpakistan.com/adventurist/public/assets/uploads/\( self.userBookMarkImages!.pictures[indexPath.row].image!)"), placeholder: nil)

       return galleryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC{
            controller.picID = self.userBookMarkImages!.pictures[indexPath.row].id!
            controller.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(controller, animated: true)
        }
    }
}



