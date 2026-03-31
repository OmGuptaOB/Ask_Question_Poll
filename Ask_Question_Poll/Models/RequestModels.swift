//
//  RequestModels.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 30/03/26.
//

import Foundation
import ObjectMapper


//MARK: Login Request Model
class LoginRequestModel: Mappable {
    
    var email_id: String?
    var password: String?
    var device_info: DeviceInfo?
    
    required init?(map: Map) {}
    
    init(email: String, password: String) {
        self.email_id = email
        self.password = password
        self.device_info = DeviceInfo()
    }
    
    func mapping(map: Map) {
        email_id    <- map["email_id"]
        password    <- map["password"]
        device_info <- map["device_info"]
    }
}

class DeviceInfo: Mappable {
    
    var device_reg_id: String?
    var device_platform: String?
    var device_model_name: String?
    var device_vendor_name: String?
    var device_os_version: String?
    var device_udid: String?
    var device_resolution: String?
    var device_carrier: String?
    var device_country_code: String?
    var device_language: String?
    var device_local_code: String?   //note: key has $
    var device_default_time_zone: String?
    var device_library_version: String?
    var device_application_version: String?
    var device_type: String?
    var device_registration_date: String?
    var is_active: String?
    
    required init?(map: Map) {}
    
    init() {
        self.device_reg_id = "TEST_REG_ID"
        self.device_platform = "ios"
        self.device_model_name = UIDevice.current.model
        self.device_vendor_name = "Apple"
        self.device_os_version = UIDevice.current.systemVersion
        self.device_udid = UIDevice.current.identifierForVendor?.uuidString
        self.device_resolution = "\(UIScreen.main.bounds.width)*\(UIScreen.main.bounds.height)"
        self.device_carrier = ""
        self.device_country_code = "IN"
        self.device_language = Locale.current.identifier
        self.device_local_code = Locale.current.identifier
        self.device_default_time_zone = TimeZone.current.identifier
        self.device_library_version = ""
        self.device_application_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.device_type = "phone"
        self.device_registration_date = "\(Date())"
        self.is_active = "0"
    }
    
    func mapping(map: Map) {
        device_reg_id             <- map["device_reg_id"]
        device_platform           <- map["device_platform"]
        device_model_name         <- map["device_model_name"]
        device_vendor_name        <- map["device_vendor_name"]
        device_os_version         <- map["device_os_version"]
        device_udid               <- map["device_udid"]
        device_resolution         <- map["device_resolution"]
        device_carrier            <- map["device_carrier"]
        device_country_code       <- map["device_country_code"]
        device_language           <- map["device_language"]
        device_local_code         <- map["$device_local_code"] // $ key
        device_default_time_zone  <- map["device_default_time_zone"]
        device_library_version    <- map["device_library_version"]
        device_application_version <- map["device_application_version"]
        device_type               <- map["device_type"]
        device_registration_date  <- map["device_registration_date"]
        is_active                 <- map["is_active"]
    }
}

//MARK: Signup Request Model
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

//MARK: OTP Request Model

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

//MARK: forgot password Request Model
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

//MARK: Verify forgot otp Request Model
class VerifyForgotOTPRequestModel: Mappable {
    
    var email_id: String?
    var token:    Int?
    
    init(email: String, token: Int) {
        self.email_id = email
        self.token    = token
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        token    <- map["token"]
    }
}


//MARK: reset Password Request Model
class ResetPasswordRequestModel: Mappable {
    var email_id: String?
    var token:    String?
    var password: String?
    
    init(email: String, token: String, password: String) {
        self.email_id = email
        self.token    = token
        self.password = password
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        email_id <- map["email_id"]
        token    <- map["token"]
        password <- map["password"]
    }
}

//MARK: Add Question Request Model
class AddQuestionRequestModel: Mappable {
    var category_id:  Int?
    var country:      String?
    var gender:       Int?
    var description:  String?
    var option_type:  Int?      // 1 = text, 2 = image
    var option1:      String?   // text option 1 (only for text mode)
    var option2:      String?   // text option 2 (only for text mode)
    
    var questionImage: UIImage?
    var optionOneImage: UIImage?
    var optionTwoImage: UIImage?
    
    required init?(map: Map) {}
    
    init(categoryId: Int, country: String?, gender: Int?,
         description: String, optionType: Int,
         option1: String? = nil, option2: String? = nil,
         questionImage: UIImage? = nil,
         optionOneImage: UIImage? = nil,
         optionTwoImage: UIImage? = nil) {
        
        self.category_id   = categoryId
        self.country       = country
        self.gender        = gender
        self.description   = description
        self.option_type   = optionType
        self.option1       = option1
        self.option2       = option2
        self.questionImage  = questionImage
        self.optionOneImage = optionOneImage
        self.optionTwoImage = optionTwoImage
    }
    
    func mapping(map: Map) {
        category_id  <- map["category_id"]
        country      <- map["country"]
        gender       <- map["gender"]
        description  <- map["description"]
        option_type  <- map["option_type"]
        option1      <- map["option1"]
        option2      <- map["option2"]
    }
    
    // Build request_data JSON — text fields only
    func toRequestDataJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let categoryId = category_id {
            dict["category_id"]  = categoryId
        }
        if let country = country {
            dict["country"] = country
        }
        if let gender = gender {
            dict["gender"] = gender
        }
        if let desc = description {
            dict["description"] = desc
        }
        if let optType = option_type {
            dict["option_type"] = optType
        }
        
        // Only add text options if text mode
        if option_type == 1 {
            if let opt1 = option1 {
                dict["option1"] = opt1
            }
            if let opt2 = option2 {
                dict["option2"] = opt2
            }
        }
        return dict
    }
}

