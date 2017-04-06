//
//  Card.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/15.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import Foundation

class Card {
    
    // model variables
    var CardKey: String?
    
    var name: String?
    var tel: String?
    var job: String?
    var address: String?
    var email: String?
    var com: String?  // 公司名称
    
    init(key: String) {
        self.CardKey = key
    }
    init(key: String, name: String?, tel: String?, job: String?, address: String?,email: String?, com: String?) {
        
        self.CardKey = key
        self.name = name
        self.tel = tel
        self.job = job
        self.address = address
        self.email = email
        self.com = com
    }
    
    class func fromJson(json dict: Dictionary<String, AnyObject>) throws -> Card {
        
        guard let key = dict["key"] as? String else {
            throw ModelDataError.jsonInvalid
        }
        
        let name = dict["card_name"] as? String
        let tel = dict["card_tel"] as? String
        let job = dict["card_job"] as? String
        let address = dict["card_address"] as? String
        let email = dict["card_email"] as? String
        let com = dict["card_com"] as? String
        
        let card = Card(key:key, name: name, tel: tel, job: job, address: address, email: email, com: com)
        
        
        return card
    }
    
    public func toJson() -> Dictionary<String, AnyObject> {
        
        var json: Dictionary<String, AnyObject> = [:]
        
        if let cardKey = self.CardKey {
            json["key"] = cardKey as AnyObject
        }
        
        if let name = self.name {
            json["card_name"] = name as AnyObject
        }
        
        if let tel = self.tel {
            json["card_tel"] = tel as AnyObject
        }
        
        if let job = self.job {
            json["card_job"] = job as AnyObject
        }
        
        if let address = self.address {
            json["card_address"] = address as AnyObject
        }
        
        if let email = self.email {
            json["card_email"] = email as AnyObject
        }
        
        if let com = self.com {
            json["card_com"] = com as AnyObject
        }
       
        return json
    }
    
}

extension Card: Equatable{}
func == (lhs: Card, rhs: Card) -> Bool {
    
    return lhs.CardKey == rhs.CardKey
}

extension Card: Hashable {
    
    var hashValue: Int {
        
        get {
            return self.CardKey!.hashValue
        }
    }
}





