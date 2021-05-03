import Foundation
import SwiftyJSON


class LoginModel : NSObject, NSCoding{

    var token : String!
    var user : UserModel!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        token = json["token"].stringValue
        let userJson = json["user"]
        if !userJson.isEmpty{
            user = UserModel(fromJson: userJson)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if token != nil{
            dictionary["token"] = token
        }
        if user != nil{
            dictionary["user"] = user.toDictionary()
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        token = aDecoder.decodeObject(forKey: "token") as? String
        user = aDecoder.decodeObject(forKey: "user") as? UserModel
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
        if user != nil{
            aCoder.encode(user, forKey: "user")
        }

    }

}
