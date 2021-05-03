//
//  UIViewController.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 17/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    
    static let ActivityLoader = Activity().loadNib() as! Activity
    static let progressLoader = ProgressLoader().loadNib() as! ProgressLoader
    ///Adding Activity Loader
    func addActivityLoader(){
        UIViewController.ActivityLoader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(UIViewController.ActivityLoader)
    }
    ///removing Activity Loader
    func removeActivityLoader(){
        UIViewController.ActivityLoader.removeFromSuperview()
    }
    ///Animating View Controller like push animation....
    ///Transition
    func pushFromPresent()  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    ///Animating *back* View Controller like push animation....
    ///Transition
    func pushBack()  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    /// Error *Alert* Showing with error message....
    func ShowAlert(message : String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    /**
     uploader Functions
     */
    
    
    
    ///adding Uploader
    func Uploader(with progress: Float){
        UIViewController.progressLoader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(UIViewController.progressLoader)
        UIViewController.progressLoader.progressBar.setProgress(progress, animated: true)
        let prog = Int(progress * 100)
        UIViewController.progressLoader.progressLabel.text = "Uploading...\(prog)%"
        
    }
    func uploaderValue(progressValue : Float){
        UIViewController.progressLoader.progressBar.setProgress(progressValue, animated: true)
        let prog = Int(progressValue * 100)
        UIViewController.progressLoader.progressLabel.text = "Uploading...\(prog)%"
    }
    
    func removeUploader(){
        UIViewController.progressLoader.removeFromSuperview()
    }
}
