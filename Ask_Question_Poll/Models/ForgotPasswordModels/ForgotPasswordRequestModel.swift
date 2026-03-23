//
//  ForgotPasswordRequestModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//
import ObjectMapper

class ForgotPasswordRequestModel: Mappable {
    var email_id: String?
    
    init(email: String) {
        self.email_id = email
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
    }
}
