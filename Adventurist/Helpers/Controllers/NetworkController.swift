//
//  NetworkController.swift
//  Adventurist
//
//  Created by Touseef Sarwar on 15/09/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import GooglePlaces

class NetworkController {
    
    
    static let shared = NetworkController()
    
    //FIXME: Live
    var baseUrl = "http://adventurist-env.eba-ksni68ph.ap-east-1.elasticbeanstalk.com/api/"

    //FIXME: Stg
//    var baseUrl = "http://adventurist.plandstudios.com/api/"
    
    /// onComplition-> JSON is json response
    ///and 0 == failed due to invalid parameters
    ///and 1 == successfull case
    /// and 2== no internet available
    func Service(method : HTTPMethod , parameters : [String : Any]? , nameOfService name : WebServices, isFormData : Bool,  onComplition: @escaping (JSON, Int) -> Void) {
       
        if InternetAvailabilty.isInternetAvailable(){
            let url = "\(self.baseUrl)\(name.rawValue)"
            let headers: HTTPHeaders = [
                "Accept" : (isFormData) ? "application/x-www-form-urlencoded" : "application/json",
                "Authorization": "Bearer \(UserSession.loginSession?.token! ?? "")",
            ]
//            if isAuthorization{
//                headers = [
//                    "Accept" : (isFormData) ? "application/x-www-form-urlencoded" : "application/json",
//                    "Authorization": "Bearer \(UserSession.authorizationToken)",
//                ]
//            }else{
//                headers = [
//                    "Accept" : (isFormData) ? "application/x-www-form-urlencoded" : "application/json",
//                ]
//            }
            
            print("Body ====>  \(String(describing: parameters))")
            print("headers ====> \( String(describing: headers))")
            
            
            AF.request(url, method: method, parameters: (method == HTTPMethod.post) ? parameters : nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON(){ response in
                switch response.result{
                case.success(let data):
                    self.showRequestDetailForSuccess(responseObject: response)
                   let resp = JSON(data)
                   if response.response!.statusCode == 200 {
                    if resp["status"].boolValue == false{
                        onComplition(resp["description"] , 0)
                    }else{
                        onComplition(resp["data"] , 1)
                    }
                   }else if response.response!.statusCode == 500 || response.response!.statusCode == 501{
                    onComplition(JSON("Server Error with Status Code : \(response.response!.statusCode)"),0 )
                   }else{
                        if JSON(resp["description"]) == JSON.null{
                            onComplition(JSON("Something Went Wrong..."),0 )
                        }else{
                            onComplition(JSON(resp["description"]),0 )
                        }
                   }
                   
                    break
               case.failure(let error):
                self.showRequestDetailForFailure(responseObject: response, error: error as NSError)
                   let respError = JSON(error.errorDescription!)
                   onComplition(respError,0 )
                   break
                }
               
            }
            
        }else{
            onComplition(JSON("No Internet Connection Available"), 2)

        }
    }
    
    
    
    
    
    func UploadPicture(_ view: UIViewController?,params: [String: Any], imageFile: UIImage?, endPoint name: WebServices  =  .addPicture, isFormDataa: Bool, onComplition: @escaping (JSON, Int) -> Void) {
        if InternetAvailabilty.isInternetAvailable(){
            
            let url = "\(self.baseUrl)\(name.rawValue)"
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data",
                "Accept" : "application/json",
                "Authorization": "Bearer \(UserSession.loginSession?.token! ?? "")",
            ]
            
            print("=============>>>>>>> Parameters{ \n \(params) \n }")
            print("=============>>>>>>> Headers{ \n \(headers) \n }")
            
            view?.addActivityLoader()
            AF.upload(multipartFormData: { (multiPart) in
                
                for (key, value) in params{
                    multiPart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let  image  = imageFile{
                    multiPart.append(image.jpegData(compressionQuality: 1.0) ?? Data(), withName: "image", fileName: "adventurist_\(Date().timeIntervalSince1970).png", mimeType: "image/png")
                }
                                
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers).uploadProgress { (progress) in
                
                view?.removeActivityLoader()
                view?.Uploader(with: Float(progress.fractionCompleted))
                let prog = Int(progress.fractionCompleted * 100)
                if prog == 100{
                    view?.removeUploader()
                    view?.addActivityLoader()
                }
                
                
            }.responseJSON(){ response in
                view?.removeActivityLoader()
                switch response.result{
                case.success(let data):
                    self.showRequestDetailForSuccess(responseObject: response)
                   let resp = JSON(data)
                   if response.response?.statusCode == 200 {
                    if resp["status"].boolValue == false{
                        onComplition(resp["description"] , 0)
                    }else{
                        onComplition(resp["data"] , 1)
                    }
                   }else if response.response?.statusCode == 500 || response.response!.statusCode == 501{
                    onComplition(JSON("Server Error with Status Code : \(response.response!.statusCode)"),0 )
                   }else{
                        if JSON(resp["description"]) == JSON.null{
                            onComplition(JSON("Something Went Wrong..."),0 )
                        }else{
                            onComplition(JSON(resp["description"]),0 )
                        }
                   }
                   
                    break
               case.failure(let error):
                self.showRequestDetailForFailure(responseObject: response, error: error as NSError)
                let respError = JSON(error.errorDescription ?? "Undefined Error.")
                print(respError)
                   onComplition(respError,0 )
                   break
                }
               
            }
            
            
        }else{
            onComplition(JSON("No Internet Connection Available"),0)
        }
    }
    
}


extension NetworkController{
    
    
    func showRequestDetailForSuccess(responseObject response : AFDataResponse<Any>) {
        
        #if DEBUG
        var logString :String = ""
        logString = "\n\n\n✅✅✅ ------- Success Response Start ------- ✅✅✅ \n"
        logString += ""+(response.request?.url?.absoluteString ?? "")
        logString += "\n=========   allHTTPHeaderFields   ========== \n"
        logString += "\(response.request?.allHTTPHeaderFields ?? [:])"
        
        
        if let bodyData : Data = response.request?.httpBody {
            let bodyString = String(data: bodyData, encoding: String.Encoding.utf8)
            logString += "\n=========   Request httpBody   ========== \n" + (bodyString ?? "")
        } else {
            logString += "\n=========   Request httpBody   ========== \n" + "Found Request Body Nil"
        }
        
        logString += "\n=========   Request Total Duration   ========== \n\(response.serializationDuration)"
        
        
        if let responseData : Data = response.data {
            let responseString = String(data: responseData, encoding: String.Encoding.utf8)
            logString += "\n=========   Response Body   ========== \n" + (responseString ?? "")
        } else {
            logString += "\n=========   Response Body   ========== \n" + "Found Response Body Nil"
        }
        logString += "\n✅✅✅ ------- Success Response End ------- ✅✅✅ \n\n\n"
        
        print(logString)
        #endif
    }
    
    func showRequestDetailForFailure(responseObject response : AFDataResponse<Any>, error:NSError) {
        
        #if DEBUG
        var logString :String = ""
        logString = "\n\n\n❌❌❌❌ ------- Failure Response Start ------- ❌❌❌❌\n"
        logString += ""+(response.request?.url?.absoluteString ?? "")
        logString += "\n=========   allHTTPHeaderFields   ========== \n"
        logString += "\(response.request?.allHTTPHeaderFields ?? [:])"
        
        if let bodyData : Data = response.request?.httpBody {
            let bodyString = String(data: bodyData, encoding: String.Encoding.utf8)
            logString += "\n=========   Request httpBody   ========== \n" + (bodyString ?? "")
        } else {
            logString += "\n=========   Request httpBody   ========== \n" + "Found Request Body Nil"
        }
        
        logString += "\n=========   Request Total Duration   ========== \n\(response.serializationDuration) Secs"
        
        if let responseData : Data = response.data {
            let responseString = String(data: responseData, encoding: String.Encoding.utf8)
            logString += "\n=========   Response Body   ========== \n" + (responseString ?? "")
        } else {
            logString += "\n=========   Response Body   ========== \n" + "Found Response Body Nil"
        }
        
        if error.description.isEmpty == false {
            logString += "\n=========   Error   ========== \n" + error.description
        }
        logString += "\n❌❌❌❌ ------- Failure Response End ------- ❌❌❌❌\n\n\n"
        
        print(logString)
        #endif
        
    }
}
