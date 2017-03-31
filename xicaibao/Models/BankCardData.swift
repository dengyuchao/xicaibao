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
        
        let bankCardData = ["中国工商银行": "gongshanng", "广发银行": "guangfa", "华夏银行": "huaxia", "中国建设银行": "jianshe", "交通银行": "jiaotong", "民生银行": "minsheng", "农业银行": "nongye", "浦发银行": "pufa", "兴业银行": "xingye", "中国邮政银行": "youzheng", "招商银行": "zhaoshang", "中国银行": "zhongguo", "中信银行": "zhongxin"]
        
        return bankCardData
    }
}
