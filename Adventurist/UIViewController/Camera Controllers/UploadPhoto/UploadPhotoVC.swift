//
//  UploadPhotoVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 28/04/2021.
//  Copyright © 2021 Touseef Sarwar. All rights reserved.
//

import UIKit
import GooglePlaces
import DropDown

class UploadPhotoVC: UIViewController {
    
    static  let identifier = "UploadPhotoVC"
    
    
    //MARK: IBOutlets...
    
    @IBOutlet weak var imagepPickedd: UIImageView!
    
    @IBOutlet weak var searchPlaceTF:  UITextField!
    
    @IBOutlet weak var categryTF: UITextField!
    @IBOutlet weak var categryView: UIView!

    @IBOutlet weak var accessibilityTF: UITextField!
    @IBOutlet weak var skillLevelTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var feeTF: UITextField!
    @IBOutlet weak var tipsTF: UITextField!
    
    
    //Specification....
    @IBOutlet weak var lens: UILabel!
    @IBOutlet weak var focalStop: UILabel!
    @IBOutlet weak var focalLength: UILabel!
    @IBOutlet weak var resolution: UILabel!
    @IBOutlet weak var bitDepth: UILabel!
    @IBOutlet weak var colorRepresentation: UILabel!
    @IBOutlet weak var exposureTime: UILabel!
    @IBOutlet weak var isoSpeed: UILabel!
    @IBOutlet weak var flashMode: UILabel!
    @IBOutlet weak var aperture: UILabel!
    @IBOutlet weak var subjectDistance: UILabel!
    @IBOutlet weak var temprature: UILabel!
    @IBOutlet weak var shutter: UILabel!
    
    //MARK: Properties....
    
    let autocompleteController = GMSAutocompleteViewController()
    
    var accessibilityDD = DropDown()
    var selectedAccessibility : String?
    
    var categryDD = DropDown()
    var selectedCategory : [FilterModel]?
    
    
    let datePicker = UIDatePicker()
    let myView = UIView()
    var isStartTime: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTapGestures()
        setUpLayout()
    }
    
    
    
    func setUpLayout(){
        imagepPickedd.image = UploadSession.imagetoUpload
        self.lens.text = UploadSession.lens ?? "N/A"
        self.focalStop.text = UploadSession.focalStop ?? "N/A"
        self.focalLength.text = UploadSession.focalLength ?? "N/A"
        self.resolution.text = "\(UploadSession.imagetoUpload?.size.height ?? 0.0) x \(UploadSession.imagetoUpload?.size.width ?? 0.0)"
        
        self.bitDepth.text = UploadSession.bitDepth ?? "N/A"
        self.colorRepresentation.text = UploadSession.colorRepresentation ?? "N/A"
        self.exposureTime.text = UploadSession.exposureTime ?? "N/A"
        self.isoSpeed.text = UploadSession.isoSpeed ?? "N/A"
        self.flashMode.text = UploadSession.flashMode ?? "N/A"
        self.aperture.text = UploadSession.aperture ?? "N/A"
        self.temprature.text = UploadSession.temprature ?? "N/A"
        self.shutter.text = UploadSession.shutter ?? "N/A"
        self.subjectDistance.text = UploadSession.subjectDistance ?? "N/A"
        
    }
    
    
    func setUpTapGestures(){
        if #available(iOS 13.0, *) {
            let tapSPTF = UITapGestureRecognizer(target: self, action: #selector(searchPlacesClick(_:)))
            tapSPTF.numberOfTapsRequired = 1
            searchPlaceTF.addGestureRecognizer(tapSPTF)
            
            
            let tapCate = UITapGestureRecognizer(target: self, action: #selector(tapCategory(_:)))
            tapCate.numberOfTapsRequired = 1
            categryTF.addGestureRecognizer(tapCate)
            
            
            let tapStartTime = UITapGestureRecognizer(target: self, action: #selector(tapStartAction(_:)))
            tapStartTime.numberOfTapsRequired = 1
            startTimeTF.addGestureRecognizer(tapStartTime)
            
            let tapEndTime = UITapGestureRecognizer(target: self, action: #selector(tapEndAction(_:)))
            tapEndTime.numberOfTapsRequired = 1
            endTimeTF.addGestureRecognizer(tapEndTime)
            
            
            
        } else {
            // Fallback on earlier versions
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.searchPlacesClick(_:)))
            tap.numberOfTapsRequired = 1
            searchPlaceTF.addGestureRecognizer(tap)
            
            
            let tapCate = UITapGestureRecognizer(target: self, action: #selector(tapCategory(_:)))
            tapCate.numberOfTapsRequired = 1
            categryTF.addGestureRecognizer(tapCate)
            
            
            let tapStartTime = UITapGestureRecognizer(target: self, action: #selector(tapStartAction(_:)))
            tapStartTime.numberOfTapsRequired = 1
            startTimeTF.addGestureRecognizer(tapStartTime)
            
            let tapEndTime = UITapGestureRecognizer(target: self, action: #selector(tapEndAction(_:)))
            tapEndTime.numberOfTapsRequired = 1
            endTimeTF.addGestureRecognizer(tapEndTime)
            
        }
    }
    
   
     func setUpAccessibilityDropdown(){
         
         
        self.accessibilityDD.textFont = UIFont.systemFont(ofSize: 11)
        self.accessibilityDD.dismissMode = .onTap
        self.accessibilityDD.anchorView = self.accessibilityTF
        self.accessibilityDD.direction = .any
        self.accessibilityDD.topOffset = CGPoint(x: 0, y: -(self.accessibilityDD.anchorView?.plainView.bounds.height)!)
        self.accessibilityDD.bottomOffset = CGPoint(x: 0, y:(self.accessibilityDD.anchorView?.plainView.bounds.height)!)
        self.accessibilityDD.width = self.accessibilityTF.frame.width
        self.accessibilityDD.dataSource = ["public-area","private-area","restricted-area"]
        self.accessibilityDD.selectionAction = {[unowned self] (index: Int, item: String) in
            print(item)
            self.accessibilityTF.text = item
        }
        self.accessibilityDD.show()
        
     }
     
    
     func setupCategoryDD(){
         
        self.categryDD.textFont = UIFont.systemFont(ofSize: 11)
        self.categryDD.dismissMode = .onTap
        self.categryDD.anchorView = self.categryTF
        self.categryDD.direction = .any
        self.categryDD.topOffset = CGPoint(x: 0, y: -(self.categryDD.anchorView?.plainView.bounds.height)!)
        self.categryDD.bottomOffset = CGPoint(x: 0, y:(self.categryDD.anchorView?.plainView.bounds.height)!)
        self.categryDD.width = self.categryTF.frame.width
        self.categryDD.dataSource = UserSession.generalFilters.sorted(by: { $0.name < $1.name }).map({ $0.name})
        self.categryDD.multiSelectionAction = { [unowned self] (index: [Int], items: [String]) in
        
        }
        self.categryDD.show()
         
     }
     
    
}

//MARK: IBACTIONS....

extension UploadPhotoVC{
    
    @objc func tapCategory(_ sender : UITapGestureRecognizer){
        self.setupCategoryDD()
    }
    
    @IBAction func selectAccessibilityBtn(_ sender : UIButton){
        self.setUpAccessibilityDropdown()
    }

    @IBAction func backBtn(_ sender: UIBarButtonItem){
        self.pushBack()
        self.dismiss(animated: true)
    }
    
    @IBAction func upload(_ sender: UIButton){
        
        if self.searchPlaceTF.text?.isEmpty ?? true{
            self.ShowAlert(message: "Please choose address")
            return
        }
        
        if self.selectedCategory?.count ?? 0 <= 0{
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
    
    @objc func tapStartAction(_ sender: UITapGestureRecognizer){
        isStartTime = true
        showTimePicker()
    }
    @objc func tapEndAction(_ sender: UITapGestureRecognizer){
        isStartTime = false
        showTimePicker()
    }
    
}


//MARK: GooglePlaces
extension UploadPhotoVC: GMSAutocompleteViewControllerDelegate {
        
    @objc func searchPlacesClick(_ sender : UITapGestureRecognizer){
        
        if self.searchPlaceTF.text!.isEmpty{
            autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
        }else{
            self.present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.getDetails(fromaddressComponent: place)
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
    
    
    
    func getDetails(fromaddressComponent place: GMSPlace) {
        
        // Show HouseAndFlat
        if place.name?.description != nil {
            self.searchPlaceTF.text = place.name?.description ?? ""
        }
        UploadSession.lat = String(place.formattedAddress ?? "")
        // Show latitude
        if place.coordinate.latitude.description.count != 0 {
            UploadSession.lat = String(place.coordinate.latitude)
        }
        // Show longitude
        if place.coordinate.longitude.description.count != 0 {
          UploadSession.lng = String(place.coordinate.longitude)
        }

        // Show AddressComponents
        if place.addressComponents != nil {
            
            for addressComponent in (place.addressComponents)! {
               for type in (addressComponent.types){
                   switch(type){
                        case "sublocality_level_2": //street address
                            UploadSession.streetAddress = String(addressComponent.name)
                        case "sublocality_level_1":
                            print("[\(type)           :        \(addressComponent.name)]")
                        case "administrative_area_level_2": //city
                            UploadSession.city = String(addressComponent.name)
                        case "administrative_area_level_1": //province
                            UploadSession.state = String(addressComponent.name)
                        case "country": //country
                            UploadSession.country = String(addressComponent.name)
                        case "postal_code":
                            UploadSession.zip = String(addressComponent.name)
                   default:
                       break
                   }
               }
           }
        }
    }
}





//MARK: - DatePicker Methods
extension UploadPhotoVC{
    
    func showTimePicker(){
        //Formate Date
        datePicker.datePickerMode = .time
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolbar.backgroundColor = #colorLiteral(red: 0.4855657816, green: 0, blue: 0.680799365, alpha: 1)
        
        datePicker.timeZone =  TimeZone.current
        
        datePicker.backgroundColor = UIColor.lightGray
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            toolbar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        }
        
        datePicker.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
        myView.frame = CGRect(x: 0, y:((UIScreen.main.bounds.height * 0.6) - 40), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
        
        if #available(iOS 13.4, *) {
            datePicker.alignmentRect(forFrame: myView.frame)
        }
        
        myView .addSubview(toolbar)
        myView .addSubview(datePicker)
        myView.backgroundColor = UIColor.white
        
        self.view.addSubview(myView)
        
    }
    
    @objc func doneDatePicker() {
        //For date formate
        
        self.view.endEditing(true)
        myView .removeFromSuperview()
        
        if isStartTime ?? true{
            self.startTimeTF.text =  datePicker.date.toString("hh: mm a")
        }else{
            
            
            if datePicker.date.time ==  Time(getDate(from: self.startTimeTF.text ?? "")){
                self.endTimeTF.text =  datePicker.date.toString("hh: mm a")
                return
            }
            self.endTimeTF.text =  datePicker.date.toString("hh: mm a")
                
            
        }
        
    }
    
    
    func getDate(from stringdate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: stringdate)
        return date ?? Date()
    }
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
        myView .removeFromSuperview()
    }
}
