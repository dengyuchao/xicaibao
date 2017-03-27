//
//  ApiManager.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation
import Alamofire

// API 请求管理类
class ApiManager {
    var apiUrl = AppSecrets.API_URL
    
    init() {}
    
    // 登录 电话、密码
    func postLogin(tel: String, password:String,
                   successBlock: @escaping (_ user: User, _ authToken: String) ->Void,errorBlock: @escaping (_ error:Error?) -> Void){
        
        let params = ["tel": tel, "password": password]
        let url = URL(string: "\(self.apiUrl)/users/sign_in/")!
        let headers = ApiManager.headersJsonOnly()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                errorBlock(error as Error)
                return
            }
            
            // parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                do {
                    let authToken = try User.authFromJson(json: jsonObj)
                    // 查看返回的json格式
//                    guard let userJson = jsonObj["user"] as? Dictionary<String, AnyObject> else {
//                        throw ModelDataError.jsonInvalid
//                    }
//                    let user = try User.fromJson(json: userJson)
                    
                    let user = try User.fromJson(json: jsonObj)
                    
                    successBlock(user, authToken)
                    
                } catch let error as Error {
                    errorBlock(error)
                }
            } else {
                print("[ApiManager postLogin] success, but response was not Dictionary<String, AnyObject>")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
        
    }
    
    // 注册 用户名、电话、密码
    func postSignup(name: String, tel: String, code:String, password: String,successBlock: @escaping (_ user: User, _ authToken: String) -> Void,errorBlock: @escaping (_ error:Error) -> Void) {
        
        // make user params
        let params = ["username": name, "user_tel": tel, "code": code,"password": password]
        
        postSignupParams(withParams: params as Dictionary<String, AnyObject> , successBlock: {(user, authToken) in
            
            print("[ApiManager postSignup] signup OK, user: \(user)")
            successBlock(user, authToken)
            
        }, errorBlock: {(error) in
            print("[ApiManager postSignup] success, but response was not Dictionary<String, AnyObject>")
            errorBlock(error)
        })
        
    }
    
    private func postSignupParams(withParams params: Dictionary<String, AnyObject>,successBlock: @escaping (_ user: User, _ authToken: String) -> Void,errorBlock: @escaping (_ error:Error) -> Void) {
        
        let url = URL(string: "\(self.apiUrl)/users/")!
        
        let headers = ApiManager.headersJsonOnly()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            // manually catch error status
            let validStatusCodes = 200..<300
            let responseStatus = response.response?.statusCode ?? -1
            if !validStatusCodes.contains(responseStatus) {
                
                // parse json for error message
                if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                    // show first error
                    let title = jsonObj.keys.first ?? ""
                    let errors = jsonObj[title] as! [String]
                    let message = errors[0]  // error messages returns as array
                    
                    let userInfo = ModelErrorManager.localizedUserInfo("[\(title)] \(message)", reason: "", recovery: "")
                    let error = NSError(domain: "RegistrationError", code: responseStatus, userInfo: userInfo)
                    errorBlock(error)
                    return
                } else {
                    // fallback with General Error, response is not valid status code, and includes network error.
                    let error = ModelErrorManager.errorWithType(ModelDataError.generalError)
                    errorBlock(error)
                    return
                }
            }
            
            // parse JSON response as user data
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                do {
                    let authToken = try User.authFromJson(json: jsonObj)
                    //                    let userStore = try UserStore.upsert(json: jsonObj)
                    //                    let user = userStore.toData()
                    
//                    guard let userJson = jsonObj["user"] as? Dictionary<String, AnyObject> else {
//                        throw ModelDataError.jsonInvalid
//                    }
//                    let user = try User.fromJson(json: userJson)
                    
                    let user = try User.fromJson(json: jsonObj)
                    successBlock(user, authToken)
                    return
                    
                } catch let error as Error {
                    errorBlock(error)
                    return
                }
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
                return
            }
        }
    }
    
    // 重置密码
    func resetPassword(_ tel: String, password: String, code: String,successBlock: @escaping (_ user: User, _ authToken: String) -> Void,errorBlock: @escaping (_ error: Error?) -> Void) {
        
        let params = ["user_tel": tel, "password": password, "code": code]
        let url = URL(string: "\(self.apiUrl)/users/password")!
        let headers = ApiManager.headersJsonOnly()
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                errorBlock(error)
                return
            }
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                do {
                    let authToken = try User.authFromJson(json: jsonObj)
                    let user = try User.fromJson(json: jsonObj)
                    successBlock(user, authToken)
                    
                } catch let error as Error{
                    errorBlock(error)
                }
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
        
    }
    
    // MARK: User Device
    // POST /devices
    
    func postDevice(_ params: Dictionary<String, AnyObject>, forUser uuid: String, token: String, successBlock: @escaping (() -> Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let request_url = URL(string: "\(self.apiUrl)/devices/")!
        let headers = ApiManager.headers(uuid, token: token)
        
        print("[ApiManager postDevice] requestURL: \(request_url), params: \(params), headers: \(headers)")
        Alamofire.request(request_url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if let error = response.result.error {
                errorBlock(error as Error)
                return
            }
            print("[ApiManager postDevice] Device OK, JSON: " + response.result.debugDescription)
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                print("[Device POST succcess]/Device: \(jsonObj.description)")
                
                successBlock()
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager postDevice] Error: " + error.localizedDescription)
                errorBlock(error)
            }
        }
    }

}


extension ApiManager {
    
    class func headers(_ user: String, token: String) -> [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-API-USER": user,
            "X-API-TOKEN": token
        ]
    }
    
    class func headersForm(_ user: String, token: String) -> [String: String] {
        return [
            "Accept": "application/json",
            "X-API-USER": user,
            "X-API-TOKEN": token
        ]
    }
    
    class func headersJsonOnly() -> [String: String]{
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
}
