//
//  TransportationTC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 14/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import GoogleMaps

class TransportationTC: UITableViewCell {

    
    static var identifier = "TransportationTC"
    
    @IBOutlet weak var viewGMap     : GMSMapView!
    @IBOutlet weak var latLngLbl    : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ConfigureCell(data: DetailModel?){
        if let cell = data{
            self.latLngLbl.text = "\(cell.pictureDetail?.lat ?? "" )°N, \(cell.pictureDetail?.lng ?? "")°E"
            self.setUpMapWithLatlongs(lat: CLLocationDegrees(cell.pictureDetail?.lat ?? "") ?? 22.3193, lng: CLLocationDegrees(cell.pictureDetail?.lng ?? "") ?? 114.1694)
            if let lt = cell.pictureDetail?.lat, let lg = cell.pictureDetail?.lng{
                self.pinMarker(latitude: CLLocationDegrees(lt) ?? 22.3193, longitude: CLLocationDegrees(lg) ?? 114.1694)
            }
            
        }
    }
    
    
    func setUpMapWithLatlongs(lat: CLLocationDegrees, lng: CLLocationDegrees){
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng, zoom: 8)
        viewGMap.camera = camera
        
    }
    
    func pinMarker(latitude : CLLocationDegrees, longitude : CLLocationDegrees){
        let marker = GMSMarker()
        //Options for icon is name as "man_pin"---> Use when needed
        marker.icon = UIImage(named: "adv_pin")
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        marker.snippet = "Sidney"
        marker.map = viewGMap
    }
}
