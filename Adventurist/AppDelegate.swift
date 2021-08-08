//
//  AppDelegate.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 25/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import FBSDKCoreKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let googleApiKey = ""
    let defaults = UserDefaults.standard
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    let storyboardLogin = UIStoryboard(name: "LoginSignup", bundle: nil)
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        setUpNavigation()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarBarTintColor = .purple
        IQKeyboardManager.shared.toolbarTintColor = .white
        GMSServices.provideAPIKey("AIzaSyDkrmNt7yLpSO4JA9k7JdzVmX3KQrvvyzg")
        GMSPlacesClient.provideAPIKey("AIzaSyDkrmNt7yLpSO4JA9k7JdzVmX3KQrvvyzg")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
        /**
        if let dic = self.defaults.string(forKey: UserSession.keyLoginSession){
            if dic != ""{
                if let json = dic.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do {
                        //you can use vallues any where.
                        let login = LoginModel(fromJson: try JSON(data: json))
                        UserSession.loginSession = login
                        if let vc : UITabBarController = self.storyboardMain.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController{
                            vc.modalPresentationStyle = .fullScreen
                            self.window?.rootViewController = vc
                            self.window?.makeKeyAndVisible()
                        }
                        
                    } catch {
                       
                    }
                }
            }else{
                if let vc : UINavigationController = self.storyboardLogin.instantiateInitialViewController() as? UINavigationController{
                    vc.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }
            
        }else{
            if let vc : UINavigationController = self.storyboardLogin.instantiateInitialViewController() as? UINavigationController{
                vc.modalPresentationStyle = .fullScreen
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
        }
        return true*/
    
    }
    func setUpNavigation() {
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        let attributes = [NSAttributedString.Key.font:  UIFont(name: "Helvetica-Bold", size: 0.1)!, NSAttributedString.Key.foregroundColor: UIColor.clear]
        BarButtonItemAppearance.setTitleTextAttributes(attributes, for: .disabled)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

