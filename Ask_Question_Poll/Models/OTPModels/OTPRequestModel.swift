//
//  Untitled.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 20/03/26.
//
import ObjectMapper

class OTPRequestModel : Mappable{

    var user_reg_temp_id : String?
    var token : Int?
    var device_info: DeviceInfo?
    
    
    required init?(map: Map) {}
    init(user_reg_temp_id : String?, token : Int?){
        self.user_reg_temp_id = user_reg_temp_id
        self.token = token
        self.device_info = DeviceInfo()
    }
    
    func mapping(map: Map) {
        user_reg_temp_id <- map["user_reg_temp_id"]
        token <- map["token"]
        device_info <- map["device_info"]
    }
}
