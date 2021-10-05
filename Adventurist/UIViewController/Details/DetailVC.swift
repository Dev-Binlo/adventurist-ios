//
//  DetailVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 12/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    static var identifier = "DetailVC"
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var detailsTableView : UITableView!
    var refreshControl = UIRefreshControl()
    var segmentIndex = 0
    
    var picID : Int? = nil
    
    var details : DetailModel? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.PictureDetail()
        
        detailsTableView.register(UINib(nibName: HeaderVeiw.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderVeiw.identifier)
        detailsTableView.register(UINib(nibName: IntroTC.identifier, bundle: nil), forCellReuseIdentifier: IntroTC.identifier)
        detailsTableView.register(UINib(nibName: TransportationTC.identifier, bundle: nil), forCellReuseIdentifier: TransportationTC.identifier)
        detailsTableView.register(UINib(nibName: WeatherTC.identifier, bundle: nil), forCellReuseIdentifier: WeatherTC.identifier)
        detailsTableView.register(UINib(nibName: TipsTC.identifier, bundle: nil), forCellReuseIdentifier: TipsTC.identifier)
        detailsTableView.register(UINib(nibName: PhotosTC.identifier, bundle: nil), forCellReuseIdentifier: PhotosTC.identifier)
        
        detailsTableView.register(UINib(nibName: SpecsTC.identifier, bundle: nil), forCellReuseIdentifier: SpecsTC.identifier)
        detailsTableView.register(UINib(nibName: PacksTC.identifier, bundle: nil), forCellReuseIdentifier: PacksTC.identifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        detailsTableView.addSubview(refreshControl)
        
        self.detailsTableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.detailsTableView.estimatedSectionHeaderHeight = 250;
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.details = nil
        self.PictureDetail()
    }
    
    
}

//TableView Delegates....
extension DetailVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.details != nil{
            if segmentIndex == 0 {
                return 4
            }
            return 2
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentIndex == 0 {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: IntroTC.identifier, for: indexPath) as! IntroTC
                cell.ConfigureIntro(detail: self.details!)
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: TransportationTC.identifier, for: indexPath) as! TransportationTC
                cell.ConfigureCell(data: self.details!)
                return cell
//            }else if indexPath.row == 2{
//                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTC.identifier, for: indexPath) as! WeatherTC
//                return cell
            }else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: TipsTC.identifier, for: indexPath) as! TipsTC
                cell.ConfigureTips(detail: self.details!)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTC.identifier, for: indexPath) as! PhotosTC
                cell.configurePhotos(data: self.details!)
                return cell
            }
        }else{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: SpecsTC.identifier, for: indexPath) as! SpecsTC
                cell.ConfigureSpecs(detail: self.details!)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: PacksTC.identifier, for: indexPath) as! PacksTC
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = detailsTableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderVeiw.identifier) as! HeaderVeiw
        if self.details != nil {
            header.headerImage.kf.indicatorType = .activity
            header.headerImage.kf.setImage(with: URL(string: "\(self.details!.imagePrefix!.replacingOccurrences(of: "assets", with: "public/assets/"))\(self.details!.pictureDetail!.image!)"), placeholder: nil)
            header.segmentChange.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
            header.segmentChange.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
            header.segmentChange.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
            header.downloadButton.addTarget(self, action: #selector(download), for: .touchUpInside)
            header.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
            header.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        
        return header
    }
    
    
    
    @objc func segmentChange(_ segment : UISegmentedControl){
        if segment.selectedSegmentIndex  == 0{
            self.segmentIndex = segment.selectedSegmentIndex
        }else{
            self.segmentIndex = segment.selectedSegmentIndex
        }
        self.detailsTableView.reloadData()
    }
    
    @objc func download(_ sender : UIButton){
        if let controller = self.storyboardMain.instantiateViewController(withIdentifier: CategoriesVC.identifier) as? CategoriesVC {
                      controller.modalPresentationStyle = .fullScreen
            controller.picID = picID
            self.present(controller, animated: false)
        }
    }
    
    @objc func share(_ sender : UIButton){
        
    }
    
    
    @objc func back(_ sender : UIButton){
        self.pushBack()
        self.dismiss(animated: true)
    }
    
}

//API Calls....

extension DetailVC {
    
    func PictureDetail(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "id": "\(self.picID!)",
            "user_lat" : UserSession.lat!,
            "user_lng" : UserSession.lng!
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .PictureDetails, isFormData: false) { (response, status) in
            if status == 1{
                   //success cases
                print("Response ===> \(response)")
                self.details = DetailModel(response)
                self.detailsTableView.reloadData()
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
    
    
}
