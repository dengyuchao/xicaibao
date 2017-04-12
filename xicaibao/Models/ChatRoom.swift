//
//  ChatRoom.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation

class ChatRoom {
    // attributes
    var key: String = UUID().uuidString
//    var title: String? = nil
    
    // assocations
    var users: [User]
    var chatMessages: [ChatMessage]
    
    // unread messages
    var unreadCount: Int = 0
    
//    init(key: String?, title: String?) {
//        self.key = key ?? UUID().uuidString
//        self.title = title
//        self.users = []
//        self.chatMessages = []
//    }
    
    init(key: String?) {
        self.key = key ?? UUID().uuidString
        self.users = []
        self.chatMessages = []
    }
    
    // MARK: instantiate from json
    class func fromJson(json dict: Dictionary<String, AnyObject>) throws -> ChatRoom {
        
        guard let key = dict["key"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        
//        let title = dict["title"] as? String
        
//        let chatRoom = ChatRoom(key: key, title: title)
        
        let chatRoom = ChatRoom(key: key)
        
        // unread messages count  未读消息
        let unreadCount = (dict["unread_count"] as? Int) ?? 0
        chatRoom.unreadCount = unreadCount
        
        // append users
        if let usersArrayObj = dict["users"] as? [Dictionary<String, AnyObject>] {
            
            for userObj in usersArrayObj {
                let user = try User.fromJson(json: userObj)
                chatRoom.users.append(user)
            }
        }
        
        // append chat_messages  消息数量
        if let chatMessagesArrayObj = dict["chat_messages"] as? [Dictionary<String, AnyObject>] {
            
            for chatMessageObj in chatMessagesArrayObj {
                let chatMessage = try ChatMessage.fromJson(json: chatMessageObj)
                chatRoom.chatMessages.append(chatMessage)
            }
        }
        
        // append last message if available  最新消息
        if let lastMessageObj = dict["last_chat_message"] as? Dictionary<String, AnyObject> {
            let lastMessage = try ChatMessage.fromJson(json: lastMessageObj)
            if chatRoom.chatMessages.contains(lastMessage) == false {
                chatRoom.chatMessages.append(lastMessage)
            }
        }
        
        return chatRoom
    }
    
    // sort by createdAt, ascending order
    func sortMessages() {
        self.chatMessages.sort(by: {(u, v) in
            return u.createdAt.isLessThanDate(v.createdAt)
        })
    }
    
    func lastMessage() -> ChatMessage? {
        sortMessages()
        return chatMessages.last
    }
}
