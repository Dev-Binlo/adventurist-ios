//
//  EmailAddressVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 21/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class EmailAddressVC: UIViewController {

    static var identifier = "EmailAddressVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    
    let defaults = UserDefaults.standard
    var parameters : [String : Any] = [:]
    
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
       if textfield == emailTF{
           if let floatingLabelTextField  = emailTF {
               if !floatingLabelTextField.text!.isEmpty{
                   if !GlobalFunctions.isValidEmail(testStr: floatingLabelTextField.text!)  {
                       floatingLabelTextField.errorMessage = "Invalid email"
                   }else{
                       floatingLabelTextField.errorMessage = ""
                       floatingLabelTextField.errorMessage = nil
                   }
               }else{
                   floatingLabelTextField.errorMessage = ""
                   floatingLabelTextField.errorMessage = nil
               }
               
           }
       }
   }
       

    func validate() -> (Bool,String,SkyFloatingLabelTextField){
        if !self.emailTF.text!.isEmpty{
            if GlobalFunctions.isValidEmail(testStr: self.emailTF.text!)  {
                return (true,"",emailTF)
            }else{
                return (false,"Invalid email formate",emailTF)
            }
        }else{
            return (false,"Enter Email",emailTF)
        }
            
    }
    
    @IBAction func RegisterButton(_ sender : UIButton){
        
        
        let val = validate()
        if val.0 == true{
            //Call your api here...
            let  param = [
                "social_id" : self.parameters["social_id"] ?? "",
                "first_name" : self.parameters["first_name"] ?? "",
                "last_name" : self.parameters["last_name"] ?? "",
                "email" :   self.emailTF.text ?? "",
                "social_type" : self.parameters["social_type"] ?? "",
                "social_image" : self.parameters["social_image"] ?? ""
            ]
            SocialLogin(parameters: param)
            
        }else{
            if val.2 == emailTF{
                emailTF.errorMessage = val.1
            }
        }
    }

}

//API Calls

extension EmailAddressVC{
    
    func SocialLogin(parameters : [String : Any]) {

        self.addActivityLoader()
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .SocialLogin, isFormData: false) { (response, status) in
            
            
            if status == 1{
                //success cases
                self.defaults.removeObject(forKey: UserSession.keyLoginSession)
                self.defaults.setValue(response.rawString(), forKey: UserSession.keyLoginSession)
                self.defaults.synchronize()
                
                //this is not need here but we can use this where we need data....
                //Fetching data from UserDefaults and setting up in the model--->> JSOn
                let dic = self.defaults.string(forKey: UserSession.keyLoginSession)!
                if let json = dic.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do {
                        //you can use vallues any where.
                        let login = LoginModel(fromJson: try JSON(data: json))
                        UserSession.loginSession = login
                    } catch {}
                }
                
                if let tabViewController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                    tabViewController.modalPresentationStyle = .fullScreen
                    self.present(tabViewController, animated: true, completion: nil)
                }
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
