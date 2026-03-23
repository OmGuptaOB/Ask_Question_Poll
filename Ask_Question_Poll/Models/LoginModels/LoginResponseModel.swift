//
//  LoginResponseModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//
import ObjectMapper

class LoginResponseModel: Mappable {
    
    var code: Int?
    var message: String?
    var cause: String?
    var data: LoginData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}
class LoginData: Mappable {
    
    var token: String?
    var user_details: UserDetails?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        token        <- map["token"]
        user_details <- map["user_details"]
    }
}
class UserDetails: Mappable {
    
    var social_uid: String?
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email_id: String?
    var gender: String?
    var country: String?
    var profile_img_original: String?
    var profile_img_compress: String?
    var profile_img_thumbnail: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        social_uid              <- map["social_uid"]
        id                      <- map["id"]
        first_name              <- map["first_name"]
        last_name               <- map["last_name"]
        email_id                <- map["email_id"]
        gender                  <- map["gender"]
        country                 <- map["country"]
        profile_img_original    <- map["profile_img_original"]
        profile_img_compress    <- map["profile_img_compress"]
        profile_img_thumbnail   <- map["profile_img_thumbnail"]
    }
}
