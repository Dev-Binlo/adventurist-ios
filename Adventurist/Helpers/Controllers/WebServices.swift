//
//  WebServices.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 15/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation


//class WebServices {
//    static var Login = "login"
//    static var signUp = "signUp"
//    static var forgotPassword = "forgotPassword"
//    static var locationListing = "locationListing"
//}

enum WebServices  : String{
    
    /// *POST*  Authorization => No, formData => No, Parameter => email, password
    case Login = "login"
    
    /// *POST*  Authorization => No, formData => No, Parameter => first_name, last_name, email, password, conform_password
    case SignUp = "register"
    
    /// *GET* Authorization => Yes, formData => No, Parameter =>
    case AllUsers  = "users"
    
    /// *POST*  Authorization => No, formData => No, Parameter =>email
    case ForgotPassword = "forgot_password"
    
    /// *POST*  Authorization => No, formData => No, Parameter =>email, password
    case ResetPassword = "reset_password"
    
    
    ////Profile Api's
    /// *GET* Authorization => Yes, formData => No, Parameter => No--
    case Logout = "logout"
    
    /// *GET* Authorization => Yes, formData => No, Parameter => No--
    case DeleteAccount = "deleteAccount"
    /// *POST* Authorization => Yes, formData => No, Parameter => No--
    case EditProfile = "edit_profile"
    /// *POST* Authorization => Yes, formData => No, Parameter => No--
    case Search = "search"
    
    
    ///Dashboard Api
    /// *POST* Authorization => Yes, formData => No, Parameter => No--
    case Dashboard = "dashboard"
    ///Dashboard Api
    /// *POST* Authorization => Yes, formData => No, Parameter => No--
    case GetLocationPictures = "get_filters"
    ///Dashboard Api
    /// *POST* Authorization => Yes, formData => No, Parameter => No--
    case GetFilterPictures = "get_filters_pictures"
    
    
    /// *POST* Authorization => No, formData => No, Parameter => No--
    case SocialLogin = "social_login"
    
    /// *POST* Authorization => Yes, formData => No, Parameter => No--
    case PictureDetails = "picture_detail"
    
    case GetUsersCategories = "get_user_category";
    
    case addNewCategory = "add_user_category";
    
    case addUserPic = "add_user_picture";
    
    case deleteUserPic = "remove_user_picture";

    case addPicture  =  "add_picture";
    
}
