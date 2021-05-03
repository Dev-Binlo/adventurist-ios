//
//  ExploreVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 09/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher
import SwiftyJSON


class ExploreVC: UIViewController {

    static var  identifier = "ExploreVC"
    @IBOutlet weak var locationCV : UICollectionView!
    @IBOutlet weak var nearbyCV : UICollectionView!
    
    @IBOutlet weak var exploreTV : UITableView!
    var refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var placeholderTV : UILabel!
    
    //UserDefaults....
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    var exploreData : ExploreModel? = nil
    
    
    var selectedIndexLocation  = 0
    var selectedIndexNearby  = 0
    
    
    var selectedFilters : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreTV.tableFooterView = UIView()
        exploreTV.register(UINib(nibName: ExploreCell.identifier, bundle: nil), forCellReuseIdentifier: ExploreCell.identifier)
        locationCV.register(UINib(nibName: LocationCell.identifier, bundle: nil), forCellWithReuseIdentifier: LocationCell.identifier)
        nearbyCV.register(UINib(nibName: NearByCell.identifier, bundle: nil), forCellWithReuseIdentifier: NearByCell.identifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        exploreTV.addSubview(refreshControl)
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.exploreData = nil
        self.Explore()
    }
   
}


//Location delegates

extension ExploreVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        UserSession.lat = locValue.latitude
        UserSession.lng = locValue.longitude
        self.locationManager.stopUpdatingLocation()
        self.Explore()
        
    }
}


//TableView Delegates....
extension ExploreVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (exploreImage.count == 0) ? 0 : exploreImage.count
        return ((exploreData != nil) ? (exploreData?.pictures.count == 0) ? 0 : exploreData?.pictures.count : 0) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreCell.identifier, for: indexPath) as! ExploreCell
        
        
        cell.img.kf.indicatorType = .activity
        if let img = self.exploreData?.pictures[indexPath.row].image{
            cell.img.kf.setImage(with: URL(string: "\(exploreData!.imagePrefix!.replacingOccurrences(of: "assets", with: "public/assets/"))thumb_\(img)"), placeholder: nil)
        }
        
        
//        cell.img.image = UIImage(named: self.exploreImage[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC{
            controller.picID = self.exploreData?.pictures?[indexPath.row].id!
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
    }
    
    
}




//CollectionView delegates.....
extension ExploreVC : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == locationCV{
            return ((exploreData != nil) ? (exploreData?.cities?.count == 0) ? 0 : exploreData?.cities?.count : 0) ?? 0
        }else{
            return ((exploreData != nil) ? (exploreData?.filters?.count == 0) ? 0 : exploreData?.filters?.count : 0) ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == locationCV{
            let locCell = locationCV.dequeueReusableCell(withReuseIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
            
            if indexPath.row == selectedIndexLocation{
                locCell.locationLabel.textColor = #colorLiteral(red: 0.4706215262, green: 0, blue: 0.7214610577, alpha: 1)
            }else{
                locCell.locationLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
            locCell.locationLabel.text = exploreData?.cities?[indexPath.row].city!
            
            return locCell
        }else{
            let nearbyCell = nearbyCV.dequeueReusableCell(withReuseIdentifier: NearByCell.identifier, for: indexPath) as! NearByCell
            if selectedFilters.contains((exploreData?.filters?[indexPath.row].id)!){
                nearbyCell.bg.backgroundColor = #colorLiteral(red: 0.4706215262, green: 0, blue: 0.7214610577, alpha: 1)
                nearbyCell.nearbyLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else{
                nearbyCell.bg.backgroundColor = UIColor.clear
                nearbyCell.nearbyLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
            nearbyCell.nearbyLabel.text = exploreData?.filters?[indexPath.row].name!
            
            return nearbyCell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == locationCV{
            if self.selectedIndexLocation != indexPath.row{
                self.selectedIndexLocation = indexPath.row
                self.locationCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                GetLocation()
            }
            
        }else{
            
            if indexPath.row == 0{
                self.selectedFilters.removeAll()
                self.selectedFilters.append((exploreData?.filters?[indexPath.row].id)!)
                GetFilter()
            }else{
                self.nearbyCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                if !self.selectedFilters.isEmpty{
                    if self.selectedFilters.contains((exploreData?.filters?.first!.id)!){
                        self.selectedFilters.removeFirst()
                    }
                    if self.selectedFilters.contains((exploreData?.filters?[indexPath.row].id)!){
                        let index = self.selectedFilters.firstIndex(of: (exploreData?.filters?[indexPath.row].id)!)!
                        self.selectedFilters.remove(at: index)
                        
                        if self.selectedFilters.isEmpty{
                            self.selectedFilters.append((exploreData?.filters?.first!.id)!)
                        }
                         GetFilter()
                        
                    }else{
                        self.selectedFilters.append((exploreData?.filters?[indexPath.row].id)!)
                        GetFilter()
                    }
                }else{
                    print("heres")
                }
            }
            
            
            self.nearbyCV.reloadData()
        }
        
    }
    
}

//API Calls

extension ExploreVC{
    
    func Explore(){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "lat": "\(UserSession.lat!)",
            "lng":"\(UserSession.lng!)"
//            "lat": "34.0522",
//            "lng": "-118.2437"
        ]
           NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .Dashboard, isFormData: false) { (response, status) in
            
            if status == 1{
                   //success cases
                self.exploreData = ExploreModel(fromJson: response)
                if (self.exploreData?.pictures.count)! > 0 {
                    self.exploreTV.isHidden = false
                    self.placeholderTV.isHidden = true
                }else{
                    self.exploreTV.isHidden = true
                    self.placeholderTV.isHidden = false
                }
                if (self.exploreData?.cities?.first!.city == "Current Location"){
                    self.exploreData?.cities?.first!.lat =   "\(UserSession.lat!)"
                    self.exploreData?.cities?.first!.lng =  "\(UserSession.lng!)"
                }
                let alllocation : JSON = [
                    "city_count" : "",
                    "id" : 0,
                    "city" : "All",
                    "lng" : "\(UserSession.lng!)",
                    "lat" : "\(UserSession.lat!)"
                ]
                self.exploreData?.cities?.insert(CitiesModel(fromJson: alllocation), at: 0)
                if (self.exploreData?.filters!.count)! > 0 {
                    self.selectedFilters.removeAll()
                    self.selectedFilters.append((self.exploreData?.filters?.first?.id)!)
                }
                
                self.selectedIndexLocation = 0
                UserSession.generalFilters.removeAll()
                let flt = response["general_filters"]
                for item in flt{
                    UserSession.generalFilters.append(FilterModel(item.1))
                }
                self.exploreTV.reloadData()
                self.locationCV.reloadData()
                self.nearbyCV.reloadData()
                self.refreshControl.endRefreshing()
                self.removeActivityLoader()
                   
            }else if status == 0{
                   //webservice or server errors
                self.refreshControl.endRefreshing()
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
            }else{
                   //no internet case
                self.refreshControl.endRefreshing()
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
                print(response)
            }
        }
    }
    
    func GetLocation(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "lat": self.exploreData!.cities![selectedIndexLocation].lat!,
            "lng": self.exploreData!.cities![selectedIndexLocation].lng!,
            "user_lat" : "\(UserSession.lat!)",
            "user_lng" : "\(UserSession.lng!)"
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .GetLocationPictures, isFormData: false) { (response, status) in
            
            if status == 1{
                   //success cases
                let newData = ExploreModel(fromJson: response)
                self.exploreData?.pictures = newData.pictures
                self.exploreData?.filters = newData.filters
                if (self.exploreData?.pictures.count)! > 0 {
                    self.exploreTV.isHidden = false
                    self.placeholderTV.isHidden = true
                }else{
                    self.exploreTV.isHidden = true
                    self.placeholderTV.isHidden = false
                }
                if (self.exploreData?.filters!.count)! > 0 {
                    self.selectedFilters.removeAll()
                    self.selectedFilters.append((self.exploreData?.filters?.first?.id)!)
                }
                
                self.exploreTV.reloadData()
                self.locationCV.reloadData()
                self.nearbyCV.reloadData()
                self.removeActivityLoader()
                   
            }else if status == 0{
                   //webservice or server errors
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
            }else{
                   //no internet case
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
            }
        }
    }
    
    func GetFilter(){
        let filterIDs = (self.selectedFilters.map{String($0)}).joined(separator: ",")
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "lat": "\(self.exploreData!.cities![selectedIndexLocation].lat!)",
            "lng": "\(self.exploreData!.cities![selectedIndexLocation].lng!)",
            "filters" : "\(filterIDs)",
            "user_lat" : UserSession.lat!,
            "user_lng" : UserSession.lng!
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .GetFilterPictures, isFormData: false) { (response, status) in
            
            if status == 1{
                   //success cases
//                print("Old Data")
//                self.exploreData?.pictures.forEach({ (pic) in
//                    print(pic.id)
//                })
                let newData = ExploreModel(fromJson: response)
                self.exploreData?.pictures = newData.pictures
//                print("new Data")
//                self.exploreData?.pictures.forEach({ (pic) in
//                    print(pic.id)
//                })
                if (self.exploreData?.pictures.count)! > 0 {
                    self.exploreTV.isHidden = false
                    self.placeholderTV.isHidden = true
                }else{
                    self.exploreTV.isHidden = true
                    self.placeholderTV.isHidden = false
                }
                self.exploreTV.reloadData()
                self.locationCV.reloadData()
                self.nearbyCV.reloadData()
                self.removeActivityLoader()
                   
            }else if status == 0{
                   //webservice or server errors
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
            }else{
                   //no internet case
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
            }
        }
    }
    
}
