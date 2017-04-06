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
    var authToken: String
    
    var userName: String?
    var userTel: String?
    var imageUrl: String?
    
    
    var card: Card?  //自己的名片
    
    var friends: [User]?  // 好友
    
    var receivedCards: [Card]?  // 收到的名片
    
    
    // init methods
    init(uuid: String, authToken: String) {
        self.uuid = uuid
        self.authToken = authToken
    }
    
    init(uuid: String, authToken: String, userName: String?, userTel: String?, imageUrl:String?, card: Card?) {
        self.uuid = uuid
        self.authToken = authToken
        self.userName = userName
        self.userTel = userTel
        self.imageUrl = imageUrl
        self.card = card
        
        // associations
        self.friends = []
        self.receivedCards = []
    }
    
    // MARK: instantiate from json
    class func fromJson(json dict: Dictionary<String, AnyObject>) throws -> User {
        
        guard let uuid = dict["uuid"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        
        guard let authToken = dict["currentToken"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        
        let userName = dict["user_name"] as? String
        let userTel = dict["user_tel"] as? String
        let imageUrl = dict["image_url"] as? String
        
        var card: Card? = nil
        
        if let cardDict = dict["card"] as? Dictionary<String, AnyObject> {
            card = try Card.fromJson(json: cardDict)
        }
        
        let user = User(uuid: uuid, authToken: authToken, userName: userName, userTel: userTel, imageUrl: imageUrl,card: card)
        
        // friends
        if let array = dict["friends"] as? [Dictionary<String, AnyObject>] {
            for json in array {
                let friend = try User.fromJson(json: json)
                user.friends?.append(friend)
            }
        }
        
        // received cards
        
        
        return user
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        var json: Dictionary<String, AnyObject> = [:]
        
        if let username = self.userName {
            json["user_name"] = username as AnyObject?
        }
        
        
//        if let usertel = self.userTel {
//            json["user_tel"] = usertel as AnyObject?
//        }
        
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
