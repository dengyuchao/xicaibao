//
//  User.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation
class User {
    
    // model variables
    let uuid: String
    
    var userName: String?
    var userTel: String?
    var imageUrl: String?
    
    // init methods
    init(uuid: String) {
        self.uuid = uuid
    }
    
    init(uuid: String, userName: String?, userTel: String?, imageUrl:String?) {
        self.uuid = uuid
        self.userName = userName
        self.userTel = userTel
        self.imageUrl = imageUrl
    }
    
    // MARK: instantiate from json
    class func fromJson(json dict: Dictionary<String, AnyObject>) throws -> User {
        
        guard let uuid = dict["uuid"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        let userName = dict["user_name"] as? String
        let userTel = dict["user_tel"] as? String
        let imageUrl = dict["image_url"] as? String
        
        
        let user = User(uuid: uuid, userName: userName, userTel: userTel, imageUrl: imageUrl)
        
        return user
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        var json: Dictionary<String, AnyObject> = [:]
        
        if let username = self.userName {
            json["user_name"] = username as AnyObject?
        }
        
        if let usertel = self.userTel {
            json["user_tel"] = usertel as AnyObject?
        }
        
        return json
    }
    
    // MARK: Auth Token  本地存储的用户   唯一标识
    class func authFromJson(json dict: Dictionary<String, AnyObject>) throws -> String {
        guard let userDict = dict["user"] as? Dictionary<String, AnyObject> else {
            throw ModelDataError.jsonInvalid
        }
        guard let authToken = userDict["authentication_token"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        
        return authToken
    }
    
    
}
