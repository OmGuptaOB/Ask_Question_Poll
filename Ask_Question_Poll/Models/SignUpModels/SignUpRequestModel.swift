//
//  SignUpRequestModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//

import ObjectMapper

class SignUpRequestModel: Mappable {
    
    var first_name: String?
    var last_name:  String?
    var email_id:   String?
    var password:  String?
    var gender:    Int? 
    var country:   String?
    var profileImg: UIImage?
    
    init(email: String, password: String, country: String, gender: String,
         firstName: String? = nil, lastName: String? = nil, profileImg: UIImage? = nil) {
        self.email_id    = email
        self.password   = password
        self.country    = country
        self.gender     = gender == "male" ? 1 : 2
        self.first_name  = firstName
        self.last_name   = lastName
        self.profileImg = profileImg
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name  <- map["last_name"]
        email_id   <- map["email_id"]
        password  <- map["password"]
        gender    <- map["gender"]
        country   <- map["country"]
    }
    

}
