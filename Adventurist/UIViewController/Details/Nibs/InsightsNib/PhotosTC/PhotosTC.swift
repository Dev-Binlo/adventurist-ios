//
//  PhotosTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class PhotosTC: UITableViewCell {

    static var identifier = "PhotosTC"
    
    @IBOutlet weak var placeholderLabel : UILabel!
    @IBOutlet weak var photoCV : UICollectionView!
    var details : DetailModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoCV.register(UINib(nibName: GalleryCC.identifier, bundle: nil), forCellWithReuseIdentifier: GalleryCC.identifier)
        if #available(iOS 13.0, *) {
            photoCV.collectionViewLayout = CustomCollectionViewLayouts.MosaicReduxLayout()
        } else {
        }
        
        photoCV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configurePhotos(data : DetailModel){
        self.details = data
        if self.details!.picturesNearby!.count > 0 {
            self.photoCV.isHidden = false
            self.placeholderLabel.isHidden = true
        }else{
            self.photoCV.isHidden = true
            self.placeholderLabel.isHidden = false
        }
        photoCV.reloadData()
    }
}




extension PhotosTC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.details != nil) ? (self.details!.picturesNearby!.count > 0) ? self.details!.picturesNearby!.count : 0 : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryCell = photoCV.dequeueReusableCell(withReuseIdentifier: GalleryCC.identifier, for: indexPath) as! GalleryCC

        galleryCell.galleryImg.kf.setImage(with: URL(string: "\(self.details!.imagePrefix!.replacingOccurrences(of: "assets", with: "public/assets/"))small_\(self.details!.picturesNearby![indexPath.row].image!)"), placeholder: nil)

        return galleryCell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC{
            controller.picID = self.details!.picturesNearby![indexPath.row].id!
            controller.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(controller, animated: true)
        }
    }
}

extension UIApplication
{

    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            let top = topViewController(nav.visibleViewController)
            return top
        }

        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                let top = topViewController(selected)
                return top
            }
        }

        if let presented = base?.presentedViewController
        {
            let top = topViewController(presented)
            return top
        }
        return base
    }
}
