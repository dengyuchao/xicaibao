//
//  AppSecrets.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation

struct AppSecrets {
    
    #if PRODUCTION_API
    // production
    static let API_URL = ""
    // TODO：上线生产版本需要重新生成
    static let MOB_SMS_APP_KEY = "1c65c274df111"
    static let MOB_SMS_APP_SECRET = "e085c0bba93e6d2e783f847b7374bc1c"

    #else
    
    // QA
    static let API_URL = ""
    // SMS verification SDK
    static let MOB_SMS_APP_KEY = "1c65c274df111"
    static let MOB_SMS_APP_SECRET = "e085c0bba93e6d2e783f847b7374bc1c"
    
    #endif
    
    // 通用
    // device registration, for apns
    static let kDeviceToken = "com.xicaibao.deviceToken"
    
    
}
