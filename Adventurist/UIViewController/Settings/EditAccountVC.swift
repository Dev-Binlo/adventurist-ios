//
//  EditAccountVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 01/10/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class EditAccountVC: UIViewController {

    static var identifier = "EditAccountVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var firstNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var dobTF: SkyFloatingLabelTextField!
    @IBOutlet weak var maleBtn : UIButton!
    @IBOutlet weak var femaleBtn : UIButton!
    
    var gender : String = "male"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        firstNameTF.text = UserSession.loginSession!.user!.firstName!
        lastNameTF.text = UserSession.loginSession!.user!.lastName!
        dobTF.text = UserSession.loginSession!.user!.dob!.toDate("YYYY-MM-dd").toString("MMM dd, YYYY")
        if UserSession.loginSession!.user!.gender! == "female"{
            self.gender = "female"
            self.femaleBtn.setImage(#imageLiteral(resourceName: "on_radio"), for: .normal)
            self.maleBtn.setImage(#imageLiteral(resourceName: "off_radio"), for: .normal)
        }else{
            self.gender = "male"
            self.maleBtn.setImage(#imageLiteral(resourceName: "on_radio"), for: .normal)
            self.femaleBtn.setImage(#imageLiteral(resourceName: "off_radio"), for: .normal)
        }
        firstNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if #available(iOS 13.0, *) {
            let tapDOB = UITapGestureRecognizer(target: self, action: #selector(tapDOB(_:)))
            tapDOB.numberOfTapsRequired = 1
            dobTF.addGestureRecognizer(tapDOB)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    @objc func tapDOB(_ sender : UITapGestureRecognizer){
        
        RPicker.selectDate(title: "Date of birth", cancelText: "Cancel", doneText: "Done", datePickerMode: .date, minDate: nil, maxDate: Date()) { (selected) in
            self.dobTF.text = selected.toString("MMM dd, YYYY")
        }
    }
    
    
    @IBAction func genderSelection(_ sender : UIButton){
           if sender.titleLabel?.text == "Male"{
               self.gender = "male"
               sender.setImage(#imageLiteral(resourceName: "on_radio"), for: .normal)
               self.femaleBtn.setImage(#imageLiteral(resourceName: "off_radio"), for: .normal)
           }else{
               self.gender = "female"
               sender.setImage(#imageLiteral(resourceName: "on_radio"), for: .normal)
               self.maleBtn.setImage(#imageLiteral(resourceName: "off_radio"), for: .normal)
           }
       }
       
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if textfield == firstNameTF{
            if let floatingLabelTextField  = firstNameTF {
                floatingLabelTextField.errorMessage = ""
                floatingLabelTextField.errorMessage = nil
            }
        }else if textfield == lastNameTF{
            if let floatingLabelTextField  = lastNameTF{
                floatingLabelTextField.errorMessage = ""
                floatingLabelTextField.errorMessage = nil
            }
        }else if textfield == dobTF{
            if let floatingLabelTextField  = dobTF {
                floatingLabelTextField.errorMessage = ""
                floatingLabelTextField.errorMessage = nil
            }
            
        }
    }

    func validate() -> (Bool,String,SkyFloatingLabelTextField){
        if !self.firstNameTF.text!.isEmpty{
            if !self.lastNameTF.text!.isEmpty{
                print(!self.dobTF.text!.isEmpty)
                if !self.dobTF.text!.isEmpty{
                    return (true,"", dobTF)
                }else{
                    return (false,"Select DOB",dobTF)
                }
            }else{
                return (false,"Enter Last Name",lastNameTF)
            }
        }else{
            return (false,"Enter First Name",firstNameTF)
        }
    }
    
    @IBAction func updateButton(_ sender: ButtonY){
        let val = validate()
        if val.0 == true{
            //Call your api here...
            self.UpdateSettings()
        }else{
            if val.2 == firstNameTF{
                firstNameTF.errorMessage = val.1
            }else if val.2 == lastNameTF{
                lastNameTF.errorMessage = val.1
            }else if val.2 == dobTF{
                dobTF.errorMessage = val.1
            }
        }
    }
    
    @IBAction func backButton(_ sender : UIButton){
        self.pushBack()
        self.dismiss(animated: true, completion: nil)
    }

    
}




extension EditAccountVC{
    
    func UpdateSettings(){
          
        self.addActivityLoader()
        let parameters : [String: Any] = [
          "first_name" : firstNameTF.text!,
          "last_name" : lastNameTF.text!,
          "gender": self.gender,
          "dob" : self.dobTF.text!
        ]

        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .EditProfile, isFormData: false) { (response, status) in
          if status == 1{
            
            print("Response ===> \(response)")
            //Creating Sessions...
            let jsn : JSON = [
                "token" : UserSession.loginSession!.token!,
                "user" : response["user"]
            ]
            
            self.defaults.removeObject(forKey: UserSession.keyLoginSession)
            self.defaults.setValue(jsn.rawString(), forKey: UserSession.keyLoginSession)
            self.defaults.synchronize()
            
            //This is not need here but we can use this where we need data....
            //Fetching data from UserDefaults and setting up in the model--->> JSOn
            let dic = self.defaults.string(forKey: UserSession.keyLoginSession)!
            if let json = dic.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    //you can use vallues any where.
                    let login = LoginModel(fromJson: try JSON(data: json))
                    UserSession.loginSession = login
                } catch {
                   
                }
            }
            
            
            
//            let alert = UIAlertController(title: "Welcome to Adventurist!", message: "Your Account has been created successfully. You can explore place and do other stuff." , preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                if let tabViewController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
//                    self.present(tabViewController, animated: true, completion: nil)
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
            
            self.removeActivityLoader()
            self.dismiss(animated: true, completion: nil)
          
              
          }else if status == 0{
              //webservice or server errors
            self.removeActivityLoader()
            self.ShowAlert(message: "\(response)")
            print(response)
          }else{
              //no internet case
            self.removeActivityLoader()
            self.ShowAlert(message: "\(response)")
            print(response)
          }
          
        }
    }
    
}
