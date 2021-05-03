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
    
    @IBOutlet weak var categryTF: UITextField!
    @IBOutlet weak var categryView: UIView!
    
    @IBOutlet weak var accessibilityTF: UITextField!
    
    @IBOutlet weak var searchPlaceTF:  UITextField!
    
    //MARK: Properties....
    
    let autocompleteController = GMSAutocompleteViewController()
    
    var accessibilityDD = DropDown()
    var selectedAccessibility : String?
    
    var categryDD = DropDown()
    var selectedCategory : [FilterModel]?
    
    
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
        setUpLayout()
    }
    
    
    
    func setUpLayout(){
        imagepPickedd.image = UploadSession.imagetoUpload
        
        
    }
    
    
    
    //Dropdown
    
//    func setUpDropdown(){
//
//        self.categryDD.dataSource = UserSession.generalFilters.sorted(by: { $0.name < $1.name }).map({ $0.name})
//        self.categryDD.placeholder = "Choose Category"
//        self.categryDD.didSelectOption { (index, option) in
//            self.selectedCategory = UserSession.generalFilters[index]
//        }
//    }
    
    
   
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
        self.categryDD.anchorView = self.categryView
        self.categryDD.direction = .any
        self.categryDD.topOffset = CGPoint(x: 0, y: -(self.categryDD.anchorView?.plainView.bounds.height)!)
        self.categryDD.bottomOffset = CGPoint(x: 0, y:(self.categryDD.anchorView?.plainView.bounds.height)!)
        self.categryDD.width = self.categryView.frame.width
        self.categryDD.dataSource = UserSession.generalFilters.sorted(by: { $0.name < $1.name }).map({ $0.name})
        self.categryDD.multiSelectionAction = { [unowned self] (index: [Int], items: [String]) in
        
        }
        self.categryDD.show()
         
     }
     
    
}

//MARK: IBACTIONS....

extension UploadPhotoVC{
    
    
    
    @IBAction func selectCategoryBtn(_ sender : UIButton){
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
