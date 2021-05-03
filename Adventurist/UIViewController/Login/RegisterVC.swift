//
//  RegisterVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 10/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class RegisterVC: UIViewController {
    
    
    static var identifier = "RegisterVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var firstNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var conformPasswordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var dobTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var maleBtn : UIButton!
    @IBOutlet weak var femaleBtn : UIButton!
    
    
    var gender : String = "male"
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        conformPasswordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if #available(iOS 13.0, *) {
            let tapDOB = UITapGestureRecognizer(target: self, action: #selector(tapDOB(_:)))
            tapDOB.numberOfTapsRequired = 1
            dobTF.addGestureRecognizer(tapDOB)
        } else {
            // Fallback on earlier versions
            let tapDOB = UITapGestureRecognizer(target: self, action: #selector(tapDOB(_:)))
            tapDOB.numberOfTapsRequired = 1
            dobTF.addGestureRecognizer(tapDOB)
        }
    }
    
    
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
        }else if textfield == emailTF{
            if let floatingLabelTextField  = emailTF{
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
        } else if textfield == dobTF{
            if let floatingLabelTextField  = dobTF {
                floatingLabelTextField.errorMessage = ""
                floatingLabelTextField.errorMessage = nil
            }
            
        }
    }

    func validate() -> (Bool,String,SkyFloatingLabelTextField){
        if !self.firstNameTF.text!.isEmpty{
            if !self.lastNameTF.text!.isEmpty{
                if !self.emailTF.text!.isEmpty{
                    if GlobalFunctions.isValidEmail(testStr: self.emailTF.text!)  {
                        if !self.passwordTF.text!.isEmpty{
                            
                            if !self.conformPasswordTF.text!.isEmpty{
                                if self.passwordTF.text!.count >= 8{
                                    if self.passwordTF.text == self.conformPasswordTF.text{
                                        print(!self.dobTF.text!.isEmpty)
                                        if !self.dobTF.text!.isEmpty{
                                            return (true,"", dobTF)
                                        }else{
                                            return (false,"Select DOB",dobTF)
                                        }
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
                    }else{
                        return (false,"Invalid email formate",emailTF)
                    }
                }else{
                    return (false,"Enter Email",emailTF)
                }
            }else{
                return (false,"Enter Last Name",lastNameTF)
            }
        }else{
            return (false,"Enter First Name",firstNameTF)
        }
    }

    @IBAction func signUp(_ sender: ButtonY){
        let val = validate()
        if val.0 == true{
            //Call your api here...
            Register()
        }else{
            if val.2 == firstNameTF{
                firstNameTF.errorMessage = val.1
            }else if val.2 == lastNameTF{
                lastNameTF.errorMessage = val.1
            }else if val.2 == emailTF{
                emailTF.errorMessage = val.1
            }else if val.2 == passwordTF{
                passwordTF.errorMessage = val.1
            }else if val.2 == conformPasswordTF{
                conformPasswordTF.errorMessage = val.1
            }else if val.2 == dobTF{
                dobTF.errorMessage = val.1
            }
        }
    }
    
    @IBAction func signIn(_ sender: ButtonY){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RegisterVC{
    
    func Register(){
          
        self.addActivityLoader()
        let parameters : [String: Any] = [
          "first_name" : firstNameTF.text!,
          "last_name" : lastNameTF.text!,
          "email" : emailTF.text!,
          "password" : passwordTF.text!,
          "gender": self.gender,
          "dob" : self.dobTF.text!
        ]

        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .SignUp, isFormData: false) { (response, status) in
          if status == 1{
            
            print("Response ===> \(response)")
            //Creating Sessions...
            self.defaults.removeObject(forKey: UserSession.keyLoginSession)
            self.defaults.setValue(response.rawString(), forKey: UserSession.keyLoginSession)
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
            
            
            
            let alert = UIAlertController(title: "Welcome to Adventurist!", message: "Your Account has been created successfully. You can explore place and do other stuff." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if let tabViewController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                    self.present(tabViewController, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(tabViewController, animated: true)

                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            self.removeActivityLoader()
          
              
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
