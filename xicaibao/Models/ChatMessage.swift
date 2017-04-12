//
//  ChatMessage.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation

class ChatMessage {
    // attributes
    var key: String = UUID().uuidString
    var message: String = ""
    
    var userId: String? = nil  //发送方
    var userName: String? = nil //发送方的名字
    var createdAt: Date = Date()
    
    // assocations
    var user: User?
    
    init(key: String?, user: User?, message: String, createdAt: Date?) {
        
        self.key = key ?? UUID().uuidString
        self.user = user
        self.message = message
        if let createdAt = createdAt {self.createdAt = createdAt}
    }
    
    init(key: String?, message: String?, userId: String?, userName: String?, createdAtStr: String?) {
        
        self.key = key ?? UUID().uuidString
        self.message = message ?? ""
        self.userId = userId
        self.userName = userName
        
        if let createdAt = createdAtStr?.toDate() {
            self.createdAt = createdAt as Date
        }
    }
    
    // MARK: instantiate from json
    class func fromJson(json dict: Dictionary<String, AnyObject>) throws -> ChatMessage {
        
        guard let key = dict["key"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        
        let message = dict["message"] as? String
        let createdAtStr = dict["created_at"] as? String
        let userId = dict["sender"] as? String
        let userName = dict["sender_username"] as? String
        
        let chatMessage = ChatMessage(key: key, message: message, userId: userId, userName: userName, createdAtStr: createdAtStr)
        
        return chatMessage
    }
    
    func toJson() -> Dictionary<String, AnyObject> {
        
        let params: Dictionary<String, AnyObject> = ["key": key as AnyObject, "message": message as AnyObject]
        
        return params
        
    }
}

extension ChatMessage: Equatable{}

func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
    return lhs.key == rhs.key
}

extension ChatMessage: Hashable {
    var hashValue: Int {
        get { return self.key.hashValue }
    }
}
