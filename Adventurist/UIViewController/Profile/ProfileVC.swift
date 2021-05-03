//
//  ProfileVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 11/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var settingsBtn : UIButton!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var bookmarkCount : ButtonY!
    var bookMarkCount = 0
    var usersCategoriesModel : UserCategoryModel? = nil
    
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = UserSession.loginSession!.user!.firstName! + " " + UserSession.loginSession!.user!.lastName!
        settingsBtn.addTarget(self, action: #selector(settingAction(_:)), for: .touchUpInside)
        tableView.register(UINib(nibName: GalleryTC.identifier, bundle: nil), forCellReuseIdentifier: GalleryTC.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getuserCategories()
    }
    
    
    func getuserCategories(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "user_lat" : UserSession.lat!,
            "user_lng" : UserSession.lng!
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .GetUsersCategories, isFormData: false) { (response, status) in
            self.removeActivityLoader()
            if status == 1{
                self.usersCategoriesModel = UserCategoryModel(fromJson: response)
                if(self.usersCategoriesModel != nil){
                    self.bookMarkCount = 0
                    self.usersCategoriesModel!.userBookmarks.forEach { bookmark in
                        self.bookMarkCount = self.bookMarkCount + bookmark.pictures.count
                    }
                    self.bookmarkCount.setTitle("\(self.bookMarkCount)", for: .normal)
                }
                self.tableView.reloadData();
            }else if status == 0{
                self.ShowAlert(message: "\(response)")
            }else{
                self.ShowAlert(message: "\(response)")
            }
        }
    }
}


//TableView Delegates....

extension ProfileVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(usersCategoriesModel == nil || usersCategoriesModel?.userBookmarks.count == 0){
            return 0
        }else{
            return usersCategoriesModel!.userBookmarks.count;
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.usersCategoriesModel!.userBookmarks[section].name.capitalized
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//
//        let label = UILabel()
//        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//        label.text = self.usersCategoriesModel?.userBookmarks[section].name.capitalized
//        headerView.addSubview(label)
//
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let galleryCell = tableView.dequeueReusableCell(withIdentifier: GalleryTC.identifier, for: indexPath) as! GalleryTC
        galleryCell.userBookMarkImages = usersCategoriesModel!.userBookmarks[indexPath.section];
            return galleryCell
    }
    
    @objc func settingAction(_ sender : UIButton){
        if let controller = storyboardMain.instantiateViewController(withIdentifier: SettingsVC.identifier) as? SettingsVC {
            controller.modalPresentationStyle = .fullScreen
            self.pushFromPresent()
            self.present(controller, animated: true)
        }
    }
}
