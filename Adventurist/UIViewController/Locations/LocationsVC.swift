//
//  LocationsVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 10/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class LocationsVC: UIViewController {
    
    static var identifier = "LocationsVC"
    
    @IBOutlet weak var locationCV : UICollectionView!
    @IBOutlet weak var nearbyCV : UICollectionView!
    
    @IBOutlet weak var viewGMap: GMSMapView!
    
    //    var viewMap : GMSMapView?
    //    var locData = ["Los Angles","Hong Kong","India","England","Africa","USA","UK","Pakistan"];
    //    var nearbyData = ["Free Location","Free Location","Free Location","Free Location","Free Location"];
    //
    var exploreData : ExploreModel? = nil
    var selectedIndexLocation  = 0
    var selectedIndexNearby  = 0
    
    
    var selectedFilters : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCV.register(UINib(nibName: LocationCell.identifier, bundle: nil), forCellWithReuseIdentifier: LocationCell.identifier)
        nearbyCV.register(UINib(nibName: NearByCell.identifier, bundle: nil), forCellWithReuseIdentifier: NearByCell.identifier)
        let myLoaction = CLLocation(latitude: UserSession.lat ??  22.319  , longitude: UserSession.lng ?? 114.169)
        self.viewGMap?.isMyLocationEnabled = true
        viewGMap.settings.myLocationButton = true
        let camera = GMSCameraPosition.camera(withLatitude: myLoaction.coordinate.latitude ,longitude: myLoaction.coordinate.longitude,zoom: 16)
        viewGMap.camera = camera
        getDashBoardData();
    }
    
    
    func pinMarker(latitude : CLLocationDegrees,longitude : CLLocationDegrees){
        let marker = GMSMarker()
        //Options for icon is name as "man_pin"---> Use when needed
        marker.icon = UIImage(named: "adv_pin")
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.snippet = "Sidney"
        marker.map = viewGMap
    }
}


extension LocationsVC : UICollectionViewDataSource, UICollectionViewDelegate{
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
                getLocationPictures();
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



extension LocationsVC{
    
    func getDashBoardData(){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "lat": "\(UserSession.lat!)",
            "lng":"\(UserSession.lng!)"
            //            "lat": "34.0522",
            //            "lng": "-118.2437"
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .Dashboard, isFormData: false) { (response, status) in
            
            if status == 1{
                self.exploreData = ExploreModel(fromJson: response)
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
                self.locationCV.reloadData()
                self.nearbyCV.reloadData()
                self.viewGMap.clear()
                var bounds = GMSCoordinateBounds()
                for data in self.exploreData!.pictures{
                    
                    let latitude: CLLocationDegrees = (data.lat! as NSString).doubleValue
                    let longitude: CLLocationDegrees = (data.lng! as NSString).doubleValue
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let marker = GMSMarker()
                    marker.icon = UIImage(named: "adv_pin")
                    marker.position = location
                    marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                    marker.title = data.fullAddress
                    marker.map = self.viewGMap
                    bounds = bounds.includingCoordinate(marker.position)
                }
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                self.viewGMap.animate(with: update)
                self.removeActivityLoader()
                
            }else if status == 0{
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
            }else{
                self.removeActivityLoader()
                self.ShowAlert(message: "\(response)")
                print(response)
            }
        }
    }
    
    func getLocationPictures(){
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
                print("Response ===> \(response)")
                let newData = ExploreModel(fromJson: response)
                self.exploreData?.pictures = newData.pictures
                self.exploreData?.filters = newData.filters
                if (self.exploreData?.filters!.count)! > 0 {
                    self.selectedFilters.removeAll()
                    self.selectedFilters.append((self.exploreData?.filters?.first?.id)!)
                }
                
                self.locationCV.reloadData()
                self.nearbyCV.reloadData()
                var bounds = GMSCoordinateBounds()
                for data in self.exploreData!.pictures{
                    
                    let latitude: CLLocationDegrees = (data.lat! as NSString).doubleValue
                    let longitude: CLLocationDegrees = (data.lng! as NSString).doubleValue
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let marker = GMSMarker()
                    marker.icon = UIImage(named: "adv_pin")
                    marker.position = location
                    marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                    marker.title = data.fullAddress
                    marker.map = self.viewGMap
                    bounds = bounds.includingCoordinate(marker.position)
                }
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                self.viewGMap.animate(with: update)
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
    //
    func GetFilter(){
        let filterIDs = (self.selectedFilters.map{String($0)}).joined(separator: ",")
        self.addActivityLoader()
        print("Filters id:\(filterIDs)")
        let parameters : [String: Any] = [
            "lat": "\(self.exploreData!.cities![selectedIndexLocation].lat!)",
            "lng": "\(self.exploreData!.cities![selectedIndexLocation].lng!)",
            "filters" : "\(filterIDs)",
            "user_lat" : UserSession.lat!,
            "user_lng" : UserSession.lng!
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .GetFilterPictures, isFormData: false) { (response, status) in
            
            if status == 1{
                let newData = ExploreModel(fromJson: response)
                self.exploreData?.pictures = newData.pictures
                self.locationCV.reloadData()
                self.nearbyCV.reloadData()
                self.removeActivityLoader()
                var bounds = GMSCoordinateBounds()
                for data in self.exploreData!.pictures{
                    let latitude: CLLocationDegrees = (data.lat! as NSString).doubleValue
                    let longitude: CLLocationDegrees = (data.lng! as NSString).doubleValue
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let marker = GMSMarker()
                    marker.icon = UIImage(named: "adv_pin")
                    marker.position = location
                    marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                    marker.title = data.fullAddress
                    marker.map = self.viewGMap
                    bounds = bounds.includingCoordinate(marker.position)
                }
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                self.viewGMap.animate(with: update)
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
