//
//  VerifyEmailVC.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 17/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit

class VerifyEmailVC: UIViewController ,PhoneTextFeildDelegate {

    static var identifier = "VerifyEmailVC"
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
    
    
    @IBOutlet weak var codeTF : PhoneTextFeild!
    
    var codeReceived = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        codeTF.becomeFirstResponder()
        codeTF.numberOfDigits = 6
        codeTF.bottomBorderColor = .purple
        codeTF.nextDigitBottomBorderColor = .green
        codeTF.textColor = .purple
        codeTF.acceptableCharacters = "0123456789"
        codeTF.keyboardType = .decimalPad
        codeTF.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 1))
        codeTF.animationType = .spring
        codeTF.delegate = self
    }
    
    func digitsDidChange(digitInputView: PhoneTextFeild) {
        print("Change: " + codeTF.text)
    }
    
    func digitsDidFinish(digitInputView: PhoneTextFeild) {
        _ = codeTF.resignFirstResponder()
        print("Finish: " + codeTF.text)
        if self.codeReceived == codeTF.text{
            
            self.addActivityLoader()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Put your code which should be executed with a delay here
                
                if let controller = self.storyboardLogin.instantiateViewController(withIdentifier: ResetPasswordVC.identifier) as? ResetPasswordVC {
                    controller.modalPresentationStyle = .fullScreen
                    controller.email = self.email
                    self.pushFromPresent()
                    if UserSession.loginSession != nil{
                        self.present(controller, animated: true)
                    }else{
                        self.navigationController?.present(controller, animated: true)
                    }
                    
                }
                self.removeActivityLoader()
            }
        }else{
            self.ShowAlert(message: "Invalid code entered. Please try again!")
        }
    }

}
