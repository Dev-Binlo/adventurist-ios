//
//  ViewController.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 09/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SwiftyJSON
import FBSDKLoginKit
import AuthenticationServices


class LoginVC: UIViewController, ASAuthorizationControllerPresentationContextProviding{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    

    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    static var identifier = "LoginVC"
    
    
    let defaults = UserDefaults.standard
    let login_btn = LoginManager()
//    var data:[String:AnyObject]  = [:]
    var parameters : [String : Any] = [:]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if AccessToken.current != nil{
            login_btn.logOut()
        }
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        
        
    }
    
    @IBAction func facebookSignIn(_ sender: ButtonY){
        if AccessToken.current == nil {
            self.addActivityLoader()
            login_btn.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                
                if result != nil{
                    self.getFBUserData()
                }else{
                    self.removeActivityLoader()
                    self.login_btn.logOut()
                }
            }
        }else{
            self.removeActivityLoader()
            login_btn.logOut()
        }
    }
    
    
    @IBAction func appleSignIn(_ sender: ButtonY){
        if #available(iOS 13.0, *) {
            
            self.addActivityLoader()
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])

            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }else {
            let alert = UIAlertController(title: "Oops!", message: "Sign In with Apple is only available in iOS 13.0 or newer  " , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func signIn(_ sender: ButtonY){
        /*if let tabViewController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            tabViewController.modalPresentationStyle = .fullScreen
            self.present(tabViewController, animated: true, completion: nil)
        }
        return*/
        
        if let controller = storyboardLogin.instantiateViewController(withIdentifier: EmailLoginVC.identifier) as? EmailLoginVC {
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
    
    @IBAction func forgotPassword(_ sender: ButtonY){
        if let controller = storyboardLogin.instantiateViewController(withIdentifier: ForgotVC.identifier) as? ForgotVC {
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // Fetch Facebook Data...!
    func getFBUserData(){

        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil && result != nil{
                     let data = result as! [String : AnyObject]
                    print(data)
                    if data["email"] != nil{
                        self.parameters = [
                            "social_id" : "\(data["id"] as! String)",
                            "first_name" : "\(data["first_name"] as! String)",
                            "last_name" : "\(data["last_name"] as! String)",
                            "email" : "\(data["email"] as! String)",
                            "social_type" : "facebook",
                            "social_image" : "",
                            "dob" : "",
                            "gender" : "",
                        ]
                        
                    }else{
                        self.parameters = [
                            "social_id" : "\(data["id"] as! String)",
                            "first_name" : "\(data["first_name"] as! String)",
                            "last_name" : "\(data["last_name"] as! String)",
                            "email" : "",
                            "social_type" : "facebook",
                            "social_image" : "",
                            "dob" : "",
                            "gender" : "",
                        ]
                    }
                    print(self.parameters)
                    self.SocialLogin(parameters: self.parameters)
                }
            })
        }else{
            self.removeActivityLoader()
        }
    }
    
}

//APPLE Extension

extension LoginVC : ASAuthorizationControllerDelegate{
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
        self.removeActivityLoader()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if(appleIDCredential.realUserStatus.rawValue == 2){
                self.parameters = [
                                   "social_id" : "\(appleIDCredential.user)",
                                   "first_name" : "\(appleIDCredential.fullName!.givenName!)",
                                   "last_name" : "\(appleIDCredential.fullName!.familyName!)",
                                   "email" : "\(appleIDCredential.email!)",
                                   "social_type" : "apple",
                                   "social_image" : "",
                                   "dob" : "",
                                   "gender" : "",
                               ]
            }else{
                self.parameters = [
                    "social_id" : "\(appleIDCredential.user)",
                    "social_type" : "apple",
                ]
            }
//            if appleIDCredential.email != nil{
//                self.parameters = [
//                    "social_id" : "\(appleIDCredential.user)",
//                    "first_name" : "\(appleIDCredential.fullName!.givenName!)",
//                    "last_name" : "\(appleIDCredential.fullName!.familyName!)",
//                    "email" : "\(appleIDCredential.email!)",
//                    "social_type" : "apple",
//                    "social_image" : "",
//                    "dob" : "",
//                    "gender" : "",
//                ]
//            }else{
//                self.parameters = [
//                    "social_id" : "\(appleIDCredential.user)",
//                    "first_name" : "\(appleIDCredential.fullName!.givenName!)",
//                    "last_name" : "\(appleIDCredential.fullName!.familyName!)",
//                    "email" : "",
//                    "social_type" : "apple",
//                    "social_image" : "",
//                    "dob" : "",
//                    "gender" : "",
//                ]
//            }
            self.removeFromParent()
            self.SocialLogin(parameters: self.parameters)
            break
        default:
            print("heree")
            break
        }
    }
}


//API Calls

extension LoginVC{
    func SocialLogin(parameters : [String : Any]) {

        self.addActivityLoader()
        NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .SocialLogin, isFormData: false) { (response, status) in
            
            
            if status == 1{
                //success cases
                
                if response["user"]["email"] == JSON.null{
                    self.removeActivityLoader()
                    if let controller  = self.storyboardLogin.instantiateViewController(withIdentifier: EmailAddressVC.identifier) as? EmailAddressVC{
                        controller.parameters = self.parameters
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true)
                    }
                    
                }else{
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
                            if let tabViewController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                                tabViewController.modalPresentationStyle = .fullScreen
                                self.present(tabViewController, animated: true, completion: nil)
                            }
                            
                        } catch {
                           
                        }
                    }

                    self.removeActivityLoader()
                    
                }
                
            
                
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
