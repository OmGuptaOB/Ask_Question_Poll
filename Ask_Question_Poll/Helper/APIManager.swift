//
//  APIManager.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 19/03/26.
//

import Alamofire
import ObjectMapper

class APIManager{
    static let shared = APIManager()
    private init() {}
    let baseURL = "http://192.168.0.108/ask_question_poll/api/public"
    
    func login(request: LoginRequestModel,
               completion: @escaping (LoginResponseModel?, String?) -> Void){
        let urlString = "\(baseURL)/api/loginForUser"
        let params = request.toJSON()
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseData { response in
                // what the server actually sent back
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("LOGIN RAW RESPONSE: \(raw)")
                }
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                           let model = Mapper<LoginResponseModel>().map(JSONObject: json) {
                            completion(model, nil)
                        } else {
                            completion(nil, "Parsing Error")
                        }
                    } catch {
                        completion(nil, "Invalid server response")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
    }
    
    func signUp(request: SignUpRequestModel,
                completion: @escaping (SignUpResponseModel?, String?) -> Void) {
        
        let urlString = "\(baseURL)/api/signup"
        
        
        AF.upload(multipartFormData: { multipart in
            
            
            //
            // Append each field individually so the server receives them as separate form fields
            
            //let params = request.toJSON()
            
            //for (key, value) in params {
            //       if let strVal = "\(value)".data(using: .utf8) {
            //        multipart.append(strVal, withName: key)
            //     }
            //}
            
            // Build request_data dict exactly as server expects
            var requestData: [String: Any] = [
                "email_id": request.email_id ?? "",
                "password": request.password ?? "",
                "country":  request.country  ?? "",
                "gender":   request.gender   ?? 1
            ]
            
            // Optional fields — only add if not nil
            if let firstName = request.first_name { requestData["first_name"] = firstName }
            if let lastName  = request.last_name  { requestData["last_name"]  = lastName  }
            
            //  Serialize to JSON string and append as single "request_data" field
            if let jsonData   = try? JSONSerialization.data(withJSONObject: requestData),
               let jsonString = String(data: jsonData, encoding: .utf8),
               let fieldData  = jsonString.data(using: .utf8) {
                multipart.append(fieldData, withName: "request_data")
                print("REQUEST DATA FIELD: \(jsonString)")
            }
            
            // Profile image
            if let image      = request.profileImg,
               let imageData  = image.jpegData(compressionQuality: 0.8) {
                multipart.append(imageData,
                                 withName: "profile_img",
                                 fileName: "profile_img.jpg",
                                 mimeType: "image/jpeg")
            }
            
        }, to: urlString, method: .post)
        .responseData { response in
            // Always print what the server actually sent back
            if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                print("SIGNUP RAW RESPONSE: \(raw)")
            }
            switch response.result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                       let model = Mapper<SignUpResponseModel>().map(JSONObject: json) {
                        completion(model, nil)
                    } else {
                        completion(nil, "Parsing Error")
                    }
                } catch {
                    completion(nil, "Invalid server response")
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func verifyUser(request: OTPRequestModel,
                    completion: @escaping (OTPResponseModel?, String?) -> Void){
        let urlString = "\(baseURL)/api/verifyUser"
        let params = request.toJSON()
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseData { response in
//                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
//                    print("LOGIN RAW RESPONSE: \(raw)")
//                }
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                           let model = Mapper<OTPResponseModel>().map(JSONObject: json) {
                            completion(model, nil)
                        } else {
                            completion(nil, "Parsing Error")
                        }
                    } catch {
                        completion(nil, "Invalid server response")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
    }
    
    
    
    func forgotPassword(email: String,
                        completion: @escaping (ForgotPasswordResponseModel?, String?) -> Void) {
        
        let urlString = "\(baseURL)/api/forgotPasswordForUser"
        let params    = ForgotPasswordRequestModel(email: email).toJSON()
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseData { response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("FORGOT PASSWORD RESPONSE: \(raw)")
                }
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                           let model = Mapper<ForgotPasswordResponseModel>().map(JSONObject: json) {
                            completion(model, nil)
                        } else {
                            completion(nil, "Parsing Error")
                        }
                    } catch {
                        completion(nil, "Invalid server response")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
    }

    // ─── Verify Forgot Password OTP ───────────────────────────────

    func verifyForgotOTP(email: String, otp: Int,
                         completion: @escaping (VerifyForgotOTPResponseModel?, String?) -> Void) {
        
        let urlString = "\(baseURL)/api/verifyOtpForUser"
        let params    = VerifyForgotOTPRequestModel(email: email, token: otp).toJSON()
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseData { response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("VERIFY FORGOT OTP RESPONSE: \(raw)")
                }
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                           let model = Mapper<VerifyForgotOTPResponseModel>().map(JSONObject: json) {
                            completion(model, nil)
                        } else {
                            completion(nil, "Parsing Error")
                        }
                    } catch {
                        completion(nil, "Invalid server response")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
    }
    
    func resetPassword(email: String, token: String, password: String,
                       completion: @escaping (ResetPasswordResponseModel?, String?) -> Void) {
        
        let urlString = "\(baseURL)/api/generateNewPasswordForUser"
        let params    = ResetPasswordRequestModel(email: email, token: token, password: password).toJSON()
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseData { response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("RESET PASSWORD RESPONSE: \(raw)")
                }
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                           let model = Mapper<ResetPasswordResponseModel>().map(JSONObject: json) {
                            completion(model, nil)
                        } else {
                            completion(nil, "Parsing Error")
                        }
                    } catch {
                        completion(nil, "Invalid server response")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
    }

}
