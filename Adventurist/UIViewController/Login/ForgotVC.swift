//
//  ForgotVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 15/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotVC: UIViewController {

    static var identifier = "ForgotVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
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
    
    @IBAction func sendCodeButton(_ sender : UIButton){
        
        
        let val = validate()
        if val.0 == true{
            //Call your api here...
            ForgotPassword()
//            if let controller = self.storyboardLogin.instantiateViewController(withIdentifier: VerifyEmailVC.identifier) as? VerifyEmailVC {
//                controller.modalPresentationStyle = .fullScreen
//                controller.email = self.emailTF.text!
//                controller.codeReceived = "123456"
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
        }else{
            if val.2 == emailTF{
                emailTF.errorMessage = val.1
            }
        }
    }

}


extension ForgotVC{
    
    func ForgotPassword(){
           self.addActivityLoader()
           let parameters : [String: Any] = [
               "email" : emailTF.text!,
           ]
           NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .ForgotPassword, isFormData: false) { (response, status) in
               
            if status == 1{
                //success cases
                print(response["code"].stringValue)
                if let controller = self.storyboardLogin.instantiateViewController(withIdentifier: VerifyEmailVC.identifier) as? VerifyEmailVC {
                    controller.modalPresentationStyle = .fullScreen
                    controller.email = self.emailTF.text!
                    controller.codeReceived = response["code"].stringValue
                    self.navigationController?.pushViewController(controller, animated: true)
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
                print(response)
            }
        }
    }
}
