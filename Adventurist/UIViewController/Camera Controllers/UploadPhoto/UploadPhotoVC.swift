//
//  UploadPhotoVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 28/04/2021.
//  Copyright © 2021 Touseef Sarwar. All rights reserved.
//

import UIKit
import GooglePlaces

class UploadPhotoVC: UIViewController {
    
    static  let identifier = "UploadPhotoVC"
    
    
    //MARK: IBOutlets...
    
    @IBOutlet weak var imagepPickedd: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categryDD: UIDropDown!
    @IBOutlet weak var searchPlaceTF:  UITextField!
    
    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableView: UITableView!
    
//    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK: Properties....
    
    let autocompleteController = GMSAutocompleteViewController()
    
    var  selectedCategory : FilterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            let tapSPTF = UITapGestureRecognizer(target: self, action: #selector(searchPlacesClick(_:)))
            tapSPTF.numberOfTapsRequired = 1
            searchPlaceTF.addGestureRecognizer(tapSPTF)
        } else {
            // Fallback on earlier versions
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.searchPlacesClick(_:)))
            tap.numberOfTapsRequired = 1
            searchPlaceTF.addGestureRecognizer(tap)
        }
        
        setUpDropdown()
    }
    
    
    
    
    //Dropdown
    
    func setUpDropdown(){
        self.categryDD.dataSource = UserSession.generalFilters.sorted(by: { $0.name < $1.name }).map({ $0.name})
        self.categryDD.placeholder = "Choose Category"
        self.categryDD.didSelectOption { (index, option) in
            self.selectedCategory = UserSession.generalFilters[index]
        }
    }
    
    
}


//MARK: IBACTIONS....

extension UploadPhotoVC{
    

    @IBAction func backBtn(_ sender: UIBarButtonItem){
        self.pushBack()
        self.dismiss(animated: true)
    }
    
    @IBAction func upload(_ sender: UIButton){
        
        if self.searchPlaceTF.text?.isEmpty ?? true{
            self.ShowAlert(message: "Please choose address")
            return
        }
        
        if !self.categryDD.isSelected{
            self.ShowAlert(message: "Please choose category")
            return
        }

        
        NetworkController.shared.UploadPicture(self, params: ["skill_level":"fgdgfd"], imageFile: #imageLiteral(resourceName: "29i"), endPoint: .addPicture, isFormDataa: false) { (json, status) in
            if  status == 0 {
                print("json")
                self.ShowAlert(message: "\(json)")
                
            }else{
                self.ShowAlert(message: "\(json)")
            }
        }
    }
    
    
}


//MARK: GooglePlaces
extension UploadPhotoVC: GMSAutocompleteViewControllerDelegate {
        
    @objc func searchPlacesClick(_ sender : UITapGestureRecognizer){
        
        if self.searchPlaceTF.text!.isEmpty{
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
        }else{
            self.present(autocompleteController, animated: true, completion: nil)
        }
        
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.searchPlaceTF.text = "\(place.formattedAddress!)"
//        self.lat = "\(place.coordinate.latitude)"
//        self.lng = "\(place.coordinate.longitude)"
        
        
        viewController.dismiss(animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}





/*
 user_id
 image_date
 full_address
 plot_no
 street_address
 city
 state
 country
 zip
 lat
 lng

 category_id = array()

 skill_level
 accessibility
 fee
 start_hours
 end_hours
 tips

 camera_id
 camera_model_id
 lens
 focal_stop
 focal_length
 resolution
 bit_depth
 color_representation
 exposure_time
 iso_speed
 flash_mode
 aperture
 subject_distance
 
 
 

 */
