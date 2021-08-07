//
//  EmailLoginVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 10/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class EmailLoginVC: UIViewController {

    static var identifier = "EmailLoginVC"
    
    
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        }else if textfield == passwordTF{
            if let floatingLabelTextField  = passwordTF{
                if !floatingLabelTextField.text!.isEmpty{
                    if floatingLabelTextField.text!.count < 8{
                        floatingLabelTextField.errorMessage = "Password must be 8 characters"
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
                if !self.passwordTF.text!.isEmpty{
                    if self.passwordTF.text!.count >= 8{
                        return (true,"",passwordTF)
                    }else{
                       return (false,"Password must be 8 characters",passwordTF)
                    }
                }else{
                    return (false,"Enter Password",passwordTF)
                }
            }else{
                return (false,"Invalid email formate",emailTF)
            }
        }else{
            return (false,"Enter Email",emailTF)
        }
    }
    
    
}


// Button Actions
extension EmailLoginVC {

        @IBAction func signIn(_ sender: ButtonY){
            let val = validate()
            if val.0 == true{
                //Call your api here...
                LoginUser()
            }else{
                if val.2 == emailTF{
                    emailTF.errorMessage = val.1
                }else{
                    passwordTF.errorMessage = val.1
                }
            }
            
        
//            if let tabViewController = storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
//    //            self.present(tabViewController, animated: true, completion: nil)
//                self.navigationController?.pushViewController(tabViewController, animated: true)
//
//            }
        }

        @IBAction func forgotPassword(_ sender: ButtonY){
            if let controller = storyboardLogin.instantiateViewController(withIdentifier: ForgotVC.identifier) as? ForgotVC {
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        @IBAction func signUp(_ sender: ButtonY){
            
            if let controller = storyboardLogin.instantiateViewController(withIdentifier: RegisterVC.identifier) as? RegisterVC {
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
}




// API's Callingssss.....
extension EmailLoginVC{
    func LoginUser(){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "email" : emailTF.text ?? "",
            "password" : passwordTF.text ?? ""
        ]
        
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .Login, isFormData: false) { (response, status) in
            
            
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
                    } catch {
                       
                    }
                }
                

                if let tabViewController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                    tabViewController.modalPresentationStyle = .fullScreen
                    self.present(tabViewController, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(tabViewController, animated: true)
    
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

