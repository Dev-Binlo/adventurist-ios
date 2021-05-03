//
//  CategoriesVC.swift
//  Adventurist
//
//  Created by Muhammad Tayyab on 03/12/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit


class CategoriesVC : UIViewController{
    
    static var identifier = "CategoriesVC"
    var picID : Int!
    @IBOutlet weak var bntAddNew : UILabel!
    @IBOutlet weak var tabelView : UITableView!

    var usersCategoriesModel : UserCategoryModel? = nil
    
    override func viewDidLoad() {
        tabelView.register(UINib(nibName: SettingTC.identifier, bundle: nil), forCellReuseIdentifier: SettingTC.identifier)
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(doSomething(_:)))
        self.bntAddNew.isUserInteractionEnabled = true
        self.bntAddNew.addGestureRecognizer(labelTap)
        getuserCategories()
    }
    
    @IBAction func backButton(_ sender : UIButton){
        self.pushBack()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doSomething(_ sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField(configurationHandler: configurationTextField)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:{ (UIAlertAction)in
            let textField = alert.textFields![0] as UITextField
            self.addNewCategory(categoryName: textField.text!)
        }))

        self.present(alert, animated: true, completion: {
         print("completion block")
        })
    }

    func configurationTextField(textField: UITextField!){
         textField.placeholder = "Category Name"
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
                self.tabelView.reloadData();
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
    
    func addNewCategory(categoryName: String){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "name" : categoryName,
            "type" : "bookmark"
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .addNewCategory, isFormData: false) { (response, status) in
            self.removeActivityLoader()
            if status == 1{
                let userCategory = UserCategory(id: response["category_id"].intValue, name: categoryName)
                self.usersCategoriesModel?.userCategories.append(userCategory)
                self.tabelView.reloadData();
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
    
    func savePictureToBookMark(cateId: Int){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "category_id" : "\(cateId)",
            "picture_id" : "\(picID!)",
            "type" : "bookmark"
        ]
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .addUserPic, isFormData: false) { (response, status) in
            self.removeActivityLoader()
            if status == 1{
              self.pushBack()
              self.dismiss(animated: true, completion: nil)
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

extension CategoriesVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersCategoriesModel?.userCategories.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingTC.identifier, for: indexPath) as! SettingTC
        settingCell.itemText.text = self.usersCategoriesModel?.userCategories[indexPath.row].name
        return settingCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cateId = self.usersCategoriesModel?.userCategories[indexPath.row].id!
        savePictureToBookMark(cateId: cateId!)
    }
}
