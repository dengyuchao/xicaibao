//
//  ModelDataError.swift
//  Youli
//
//  Created by JERRY LIU on 15/10/2015.
//  Copyright © 2015 ONTHETALL. All rights reserved.
//

import Foundation


enum ModelDataError: Error {
    case entityNotValid
    case jsonInvalid
    case authenticationInvalid
    case generalError
}

class ModelErrorManager : NSObject {
    static let domain = "MODEL_DATA_ERROR"
    
    class func errorWithType(_ errorType: Error) -> NSError {
        switch errorType {
        case ModelDataError.entityNotValid:
            let code = -100
            let userInfo = ModelErrorManager.localizedUserInfo("CoreData Entity not found", reason: "Bad Entity or not available in Store", recovery: "Check and correct entity name or coredata store")
            let error = NSError(domain: ModelErrorManager.domain, code: code, userInfo: userInfo)
            return error
            
        case ModelDataError.jsonInvalid:
            let code = -200
            let userInfo = ModelErrorManager.localizedUserInfo("Failed to initialize Model from Json.", reason: "Required JSON Keys missing", recovery: "Try adding key field, and consult model init")
            let error = NSError(domain: ModelErrorManager.domain, code: code, userInfo: userInfo)
            return error
        
        case ModelDataError.authenticationInvalid:
            let code = -400
            let userInfo = ModelErrorManager.localizedUserInfo("User/token invalid", reason: "Required UUID or Auth Token invalid or missing.", recovery: "Try authentication for new session")
            let error = NSError(domain: ModelErrorManager.domain, code: code, userInfo: userInfo)
            return error
        
        case ModelDataError.generalError:
            let code = -999
            let userInfo = ModelErrorManager.localizedUserInfo("发生错误", reason: "信息发生错误, 请查看网络状态?", recovery: "Debug like hell")
            let error = NSError(domain: ModelErrorManager.domain, code: code, userInfo: userInfo)
            return error
            
        default:
            let code = -999
            let userInfo = ModelErrorManager.localizedUserInfo("Unknown Error Happened", reason: "Unknown reason", recovery: "Debug like hell")
            let error = NSError(domain: ModelErrorManager.domain, code: code, userInfo: userInfo)
            return error
            
        }
    }
    
    class func localizedUserInfo(_ desc: String, reason: String, recovery: String) -> [String: AnyObject] {
        
        let userInfo: [String: AnyObject] = [
            NSLocalizedDescriptionKey: NSLocalizedString(desc, comment: "") as AnyObject,
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, comment: "") as AnyObject,
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(recovery, comment: "") as AnyObject
        ]
        
        return userInfo
    }
}
