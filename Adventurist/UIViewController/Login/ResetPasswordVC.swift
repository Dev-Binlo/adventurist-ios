//
//  ResetPasswordVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 17/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ResetPasswordVC: UIViewController {
    static var identifier = "ResetPasswordVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var conformPasswordTF: SkyFloatingLabelTextField!
    var email = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set icon properties
//        textField2.iconType = .font
//        textField2.iconColor = UIColor.lightGrayColor()
//        textField2.selectedIconColor = overcastBlueColor
//        textField2.iconFont = UIFont(name: "FontAwesome", size: 15)
//        textField2.iconText = "\u{f072}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
//        textField2.iconMarginBottom = 4.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
//        textField2.iconRotationDegrees = 90 // rotate it 90 degrees
//        textField2.iconMarginLeft = 2.0
        self.navigationController?.navigationItem.hidesBackButton = true
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        conformPasswordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent{
            //On click of back or swipe back
            self.navigationController?.popToRootViewController(animated: false)
//            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1]) as! ForgotVC, animated: false)
        }
        if self.isBeingDismissed{
            //Dismissed
//            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1]) as! ForgotVC, animated: false)
        }
    }

    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == passwordTF{
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
        }else if textfield == conformPasswordTF{
            if let floatingLabelTextField  = conformPasswordTF{
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
        
        if !self.passwordTF.text!.isEmpty{
            
            if !self.conformPasswordTF.text!.isEmpty{
                if self.passwordTF.text!.count >= 8{
                    
                    if self.passwordTF.text == self.conformPasswordTF.text{
                        return (true,"",passwordTF)
                    }else{
                        return (false,"Password & Conform Password must be same.",passwordTF)
                    }
                }else{
                   return (false,"Password must be 8 characters",passwordTF)
                }
            }else{
                  return (false,"Enter Conform Password",conformPasswordTF)
            }
        }else{
            return (false,"Enter Password",passwordTF)
        }
    }

    @IBAction func resetButton(_ sender : UIButton){
        let val = validate()
        if val.0 == true{
            //Call your api here...
            ResetPassword()
            
//            if let controller = self.storyboardLogin.instantiateInitialViewController() as? UINavigationController{
//                controller.modalPresentationStyle = .fullScreen
//                self.present(controller, animated: true)
//            }
            
        }else{
            if val.2 == passwordTF{
                passwordTF.errorMessage = val.1
            }else{
                conformPasswordTF.errorMessage = val.1
            }
        }
    }
    
}

extension ResetPasswordVC{
    
       func ResetPassword(){
           
           self.addActivityLoader()
           let parameters : [String: Any] = [
               "email" : email,
               "password" : passwordTF.text!
           ]
           
           NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .ResetPassword, isFormData: false) { (response, status) in
               
               if status == 1{
                print("Response: ==> \(response)")
                self.removeActivityLoader()
                let alert = UIAlertController(title: "Password Changed!", message: "Your password has been changed successfully. Login again!" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Login", style: .destructive, handler: { _ in
                    if let controller = self.storyboardLogin.instantiateInitialViewController() as? UINavigationController{
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
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
