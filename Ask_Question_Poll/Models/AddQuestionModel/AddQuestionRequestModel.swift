//
//  AddQuestionRequestModel.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 24/03/26.
//

import ObjectMapper

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
        if let categoryId = category_id { dict["category_id"]  = categoryId  }
        if let country    = country     { dict["country"]       = country     }
        if let gender     = gender      { dict["gender"]        = gender      }
        if let desc       = description { dict["description"]   = desc        }
        if let optType    = option_type { dict["option_type"]   = optType     }
        
        // Only add text options if text mode
        if option_type == 1 {
            if let opt1 = option1 { dict["option1"] = opt1 }
            if let opt2 = option2 { dict["option2"] = opt2 }
        }
        return dict
    }
}
