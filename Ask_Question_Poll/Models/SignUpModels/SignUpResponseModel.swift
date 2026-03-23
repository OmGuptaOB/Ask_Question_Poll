//
//  SignUpResponseModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//

import ObjectMapper

class SignUpResponseModel: Mappable {
    
    var code:    Int?
    var message: String?
    var cause:   String?
    var data:    SignUpData?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        cause   <- map["cause"]
        data    <- map["data"]
    }
}

class SignUpData: Mappable {
    
    var userRegTempId: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userRegTempId <- map["user_reg_temp_id"]
    }
}
