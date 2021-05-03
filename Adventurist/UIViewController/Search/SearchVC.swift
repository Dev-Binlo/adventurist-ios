//
//  SearchVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 10/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchVC: UIViewController {
    
    static var  identifier = "SearchVC"
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchTF : UITextField!
    @IBOutlet weak var searchPlaceTF : UITextField!
    @IBOutlet weak var placeHolder : UILabel!
    @IBOutlet weak var searchView : UIView!
    @IBOutlet weak var searchMainButton : UIButton!
    
    
    var lat : String = ""
    var lng : String = ""
    var filterID : String = ""
    
    
    //Variables
    //filters for tableview
    var filters : [FilterModel] = []
    //Data of collection
    var picturesData : [PicturesNearby] = []
    var prefixImageURL  = ""
    
    let autocompleteController = GMSAutocompleteViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.filters.removeAll()
        self.filters = UserSession.generalFilters
        
        self.GetFilterData()
        
        
        self.searchView.isHidden = true
        self.searchMainButton.isHidden = false
        self.collectionView.isHidden = false
        self.tableView.isHidden = true
        autocompleteController.delegate = self
        
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
        
        self.tableView.tableFooterView = UIView()
        searchTF.delegate = self
        
        
        configureCollectionView()
        tableView.register(UINib(nibName: SettingTC.identifier, bundle: nil), forCellReuseIdentifier: SettingTC.identifier)
        
        
    }
    
    func configureCollectionView(){
        collectionView.register(UINib(nibName: GalleryCC.identifier, bundle: nil), forCellWithReuseIdentifier: GalleryCC.identifier)
        
        if #available(iOS 13.0, *) {
            collectionView.collectionViewLayout = CustomCollectionViewLayouts.WatterFallLayout(scrollDirection: .vertical)
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func mainSearchBtn(_ sender : UIButton){
        self.searchPlaceTF.placeholder = "Search Place"
        self.searchView.isHidden = false
        self.searchMainButton.isHidden = true
    }
    
    @IBAction func searchFilters( _ sender : ButtonY){
        
        
        //API Calls
        self.searchPlaceTF.resignFirstResponder()
        self.searchTF.resignFirstResponder()
        self.searchView.isHidden = true
        self.searchMainButton.isHidden = false
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        if self.filterID == "" && !self.searchPlaceTF.text!.isEmpty{
            self.searchMainButton.setTitle("Search in \(self.searchPlaceTF.text!)", for: .normal)
        }else if !self.searchPlaceTF.text!.isEmpty && !self.searchTF.text!.isEmpty{
            self.searchMainButton.setTitle("\(self.searchTF.text!) in \(self.searchPlaceTF.text!)", for: .normal)
        }else if self.filterID != "" && self.searchPlaceTF.text!.isEmpty{
            self.searchMainButton.setTitle("\(self.searchTF.text!)", for: .normal)
        }
        self.GetFilterData()
        
        
        
    }
    
    @IBAction func clearFilters( _ sender : ButtonY){
        self.searchView.isHidden = true
        self.searchMainButton.isHidden = false
        self.collectionView.isHidden = false
        self.tableView.isHidden = true
        self.searchTF.text! = ""
        self.searchTF.resignFirstResponder()
        self.searchPlaceTF.text! = ""
        self.searchPlaceTF.resignFirstResponder()
        self.searchMainButton.setTitle("Search", for: .normal)
        lat = ""
        lng = ""
        filterID = ""
        self.GetFilterData()
    }
    
}


extension SearchVC : UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTF{
            if searchTF.text!.isEmpty {
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
            }else{
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        filters = string.isEmpty ? UserSession.generalFilters : UserSession.generalFilters.filter({(data: FilterModel) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return data.name!.range(of: string, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
        return true
    }
    
}

//TableView Delegates....
extension SearchVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (filters.count > 0) ? filters.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTC.identifier, for: indexPath) as! SettingTC
        cell.itemText.text = filters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTF.text = self.filters[indexPath.row].name
        filterID = "\(self.filters[indexPath.row].id!)"
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
    }
    
}

//CollectionView delegates.....
extension SearchVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  (picturesData.count > 0) ? picturesData.count : 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCC.identifier, for: indexPath) as! GalleryCC

        if let img = self.picturesData[indexPath.row].image{
            galleryCell.galleryImg.kf.setImage(with: URL(string: "\(prefixImageURL)thumb_\(img)"), placeholder: nil)
        }
        return galleryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let main = UIScreen.main.bounds
        let width = main.width / 2
        let size = CGSize(width: width - 5 , height: width - 5)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC{
            controller.picID = self.picturesData[indexPath.row].id!
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
    }
    
    
}




//MARK: GooglePlaces
extension SearchVC: GMSAutocompleteViewControllerDelegate {
        
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
        self.lat = "\(place.coordinate.latitude)"
        self.lng = "\(place.coordinate.longitude)"
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


//API calls

extension SearchVC {
     func GetFilterData(){
            
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "lat": self.lat,
                "lng": self.lng,
                "filters" : self.filterID,
                "user_lat" : UserSession.lat ?? "",
                "user_lng" : UserSession.lng ?? ""
            ]
            NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .Search, isFormData: false) { (response, status) in
                
                if status == 1{
                       //success cases
                    print("Response ===> \(response)")
                    self.prefixImageURL = response["image_prefix"].stringValue.replacingOccurrences(of: "assets", with: "public/assets/")
                    let data = response["pictures"]
                    self.picturesData.removeAll()
//                    self.picturesData.append(contentsOf: [PicturesNearby(fromJson: data)])
                    for item in data{
                        self.picturesData.append(PicturesNearby(fromJson: item.1))
                    }
                    
                    if self.picturesData.count > 0{
                        self.collectionView.isHidden = false
                        self.placeHolder.isHidden = true
                    }else{
                        self.collectionView.isHidden = true
                        self.placeHolder.isHidden = false
                    }
                    
                    self.collectionView.reloadData()
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
