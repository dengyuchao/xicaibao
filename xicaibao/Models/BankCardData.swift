//
//  BankCardData.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation

class BankCardData {
    
    var bankName: String
    var iconImage: String
    
    init(name: String, icon: String) {
        
        self.bankName = name
        self.iconImage = icon
    }
    
    
    // 保存银行信息
    class func getBankCardData() -> Dictionary<String, String> {
        
        let bankCardData = ["中国工商银行": "anquan", "中国银行": "anquan", "建设银行": "anquan"]
        
        return bankCardData
    }
}
