//
//  SettingsVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 11/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import SafariServices


class SettingsVC: UIViewController {
    
    
    static var identifier = "SettingsVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var tableView : UITableView!
    
    
    //Variables
    
    let defaults = UserDefaults.standard
    var dataItems : [String] = ["Application","Change Your Password","Edit Your Account","Help Centre","Terms & Conditions","Privacy Policy","Logout","Delete Your Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        
        tableView.register(UINib(nibName: SettingTC.identifier, bundle: nil), forCellReuseIdentifier: SettingTC.identifier)
    }
    
    
    @IBAction func backButton(_ sender : UIButton){
        self.pushBack()
        self.dismiss(animated: true, completion: nil)
    }


}


//TableView Delegates....

extension SettingsVC : UITableViewDataSource , UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingTC.identifier, for: indexPath) as! SettingTC
        
        if indexPath.row == 0 || indexPath.row == 7 {
            settingCell.itemText.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }else if indexPath.row == 8 {
            settingCell.itemText.textColor = #colorLiteral(red: 0.8078431487, green: 0.0854347931, blue: 0.01955153501, alpha: 1)
        }else{
            settingCell.itemText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        settingCell.itemText.text = dataItems[indexPath.row]
        return settingCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            //call Change Password
            let alert = UIAlertController(title: "Verification Code ", message: "Sending verification code to your \"\(UserSession.loginSession!.user!.email!)\" address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Send Code", style: .default, handler: {_ in
                self.SendCode()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }else if indexPath.row == 2{
            //call Edit Your Account
            if let controller = self.storyboardMain.instantiateViewController(withIdentifier: EditAccountVC.identifier) as? EditAccountVC {
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false)
            }
        }else if indexPath.row == 3{
            //call Help Centre
            self.openWebView(with: "http://adventurist-env.eba-ksni68ph.ap-east-1.elasticbeanstalk.com/help_center")
        }else if indexPath.row == 4{
            //call Terms & Conditions
            self.openWebView(with: "http://adventurist-env.eba-ksni68ph.ap-east-1.elasticbeanstalk.com/privacy_policy")
        }else if indexPath.row == 5{
            //call Privacy Policy
            self.openWebView(with: "http://adventurist-env.eba-ksni68ph.ap-east-1.elasticbeanstalk.com/terms_and_conditions")
        }else if indexPath.row == 6{
            self.logout()
        }else  if indexPath.row == 7{
            //call deletee account
            let alert = UIAlertController(title: "Warning! Delete Account", message: "Are you sure you want to delete/deactive your Account? This action cannot be reverted.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                self.DeleteAccount()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    func openWebView(with url : String){
        let safariViewController = SFSafariViewController(url: NSURL(string: url)! as URL)
        if #available(iOS 11.0, *) {
            safariViewController.dismissButtonStyle = .close
        } else {
            // Fallback on earlier versions
        }
        self.present(safariViewController, animated: true, completion: nil)
    }
    
}



//API calls
extension SettingsVC{
    
    func logout(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            :]
        NetworkController.shared.Service(method: .get, parameters: parameters, nameOfService: .Logout, isFormData: false) { (response, status) in
              if status == 1{
                  //success cases
                self.defaults.removeObject(forKey: UserSession.keyLoginSession)
                self.defaults.setValue(response.rawString(), forKey: UserSession.keyLoginSession)
                self.defaults.synchronize()
                self.removeActivityLoader()
                if let controller = self.storyboardLogin.instantiateInitialViewController() as? UINavigationController{
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
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
    
    func DeleteAccount(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            :]
        NetworkController.shared.Service(method: .get, parameters: parameters, nameOfService: .DeleteAccount, isFormData: false) { (response, status) in
              if status == 1{
                  //success cases
                self.defaults.removeObject(forKey: UserSession.keyLoginSession)
                self.defaults.setValue(response.rawString(), forKey: UserSession.keyLoginSession)
                self.defaults.synchronize()
                self.removeActivityLoader()
                if let controller = self.storyboardLogin.instantiateInitialViewController() as? UINavigationController{
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
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
    
    func SendCode(){
           self.addActivityLoader()
           let parameters : [String: Any] = [
               "email" : UserSession.loginSession!.user!.email!,
           ]
           NetworkController.shared.Service(method: .post, parameters: parameters, nameOfService: .ForgotPassword, isFormData: false) { (response, status) in
               
            if status == 1{
                //success cases
                print(response["code"].stringValue)
                if let controller = self.storyboardLogin.instantiateViewController(withIdentifier: VerifyEmailVC.identifier) as? VerifyEmailVC {
                    controller.modalPresentationStyle = .fullScreen
                    controller.email = UserSession.loginSession!.user!.email!
                    controller.codeReceived = response["code"].stringValue
                    self.present(controller, animated: true)
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
