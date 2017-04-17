//
//  LoginManager.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation
import SAMKeychain

class LoginManager: NSObject {
    
    // auth
    var uuid: String?
    var authToken: String?
    
    // init
    override init() {
        super.init()
        loadUser()
    }
    
    // singleton manager
    class var defaultManager : LoginManager {
        struct Static {
            static let manager = LoginManager()
        }
        return Static.manager
    }
    
    // 判断登录状态
    func isLogin() -> Bool {
        if self.uuid != nil && self.authToken != nil {
            return true
        }
        return false
    }
    
    // Check for login, and show ViewController if needed
    func checkForLogin(target: AnyObject, onSuccess: @escaping ()-> Void, onCancel: (() -> Void)?) {
        
        if isLogin() {
            return onSuccess()
        }
        
        guard let loginNC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginNavigationController else { return }
        guard let loginVC = loginNC.viewControllers.first as? LoginTableViewController else { return }
        guard let target = target as? UIViewController else { return }
        
        loginVC.onSuccess = {
            target.dismiss(animated: false, completion: nil)
            onSuccess()
        }
        
//        loginVC.onCancel = onCancel
        
        target.present(loginNC, animated: false, completion: nil)
    }
    
    // MARK: login with tel/password
    func login(_ tel: String!, password: String!, onSuccess: @escaping ((_ user: User) -> Void), onFailure: @escaping (_ error: Error) -> Void) {
        
        let apiManager = ApiManager()
        apiManager.postLogin(tel: tel, password: password, successBlock: { (user, authToken) in
            
            // 登录成功保存用户uuid authToken
            self.setSession(uuid: user.uuid, authToken: authToken)
            self.saveUser()
            
            // register device 记录用户设备
            LoginManager.defaultManager.registerDevice()
            
            // callback
            onSuccess(user)
            
        }) { (error) in
            onFailure(error!)
            print("[LoginManager login] error: \(error)")
        }
    }
    
    // MARK: Signup with tel
    func signup(name: String, tel: String, code:String, password: String, onSuccess: @escaping (_ user: User) -> Void, onFailure: @escaping (_ error: Error) -> Void){
        ApiManager().postSignup(name: name, tel: tel, code: code, password: password, successBlock: { (user, authToken) in
            
            self.setSession(uuid: user.uuid, authToken: authToken)
            self.saveUser()
            
            // register device
            LoginManager.defaultManager.registerDevice()
            
            // callback
            onSuccess(user)
            
        }) { (error) in
            print("[LoginManager signup] error: \(error)")
            onFailure(error)
        }
    }
    
    // MARK: reset password 重置密码 电话号码，验证码，密码
    func resetPassword(tel: String, password: String, code: String, successBlock: @escaping (_ user: User) -> Void, errorBlock: @escaping (_ error: Error) -> Void) {
        
        ApiManager().resetPassword(tel, password: password, code: code, successBlock: { (user, authToken) in
            
            print("[LoginManager resetPassword] OK: user: \(user), authToken: \(authToken)")
            self.setSession(uuid: user.uuid, authToken: authToken)
            self.saveUser()
            
            // callback
            successBlock(user)
            
        }) { (error) in
            print("[LoginManager resetPassword] error: \(String(describing: error?.localizedDescription))")
            errorBlock(error!)
        }
    }
    
    func setSession(uuid: String, authToken: String) {
        self.uuid = uuid
        self.authToken = authToken
    }
    
    func saveUser() {
        guard let uuid = self.uuid else { return }
        guard let authToken = authToken else { return }
        // 将uuid保存到本地
        UserDefaults.standard.set(uuid, forKey: XCBLoginManagerUserDefaults.UserIdKey.rawValue)
        UserDefaults.standard.synchronize()
        let appPasswordService = XCBLoginManagerUserDefaults.UserAuthToken.rawValue
        // 加密处理
        SAMKeychain.setPassword(authToken, forService: appPasswordService, account: uuid)
    }
    
    func loadUser() {
        let appPasswordService = XCBLoginManagerUserDefaults.UserAuthToken.rawValue
        guard let uuid = UserDefaults.standard.object(forKey: XCBLoginManagerUserDefaults.UserIdKey.rawValue) as? String else { return }
        guard let authToken = SAMKeychain.password(forService: appPasswordService, account: uuid) else { return }
        
        setSession(uuid: uuid, authToken: authToken)
    }
    
    
    // MARK:登出
    func logout() {
        
        UserDefaults.standard.removeObject(forKey: XCBLoginManagerUserDefaults.UserIdKey.rawValue)
        UserDefaults.standard.synchronize()
        if let uuid = uuid {
            let appPasswordService = XCBLoginManagerUserDefaults.UserAuthToken.rawValue
            SAMKeychain.deletePassword(forService: appPasswordService, account: uuid)
            UserDefaults.standard.synchronize()
        }
        
        self.uuid = nil
        self.authToken = nil
    }
    
    // MARK: Device API
    func registerDevice() {
        // register device
        if let obj: AnyObject = UserDefaults.standard.object(forKey: AppSecrets.kDeviceToken) as AnyObject? {
            let deviceTokenData = obj as! Data
            
            let deviceToken = LoginManager.dataToHex(deviceTokenData)
            
            let params = ["device": [ ]]
            
            print("[LoginManager registerDevice] post device..... deviceToken: \(deviceToken)")
            let apiManager = ApiManager()
            apiManager.postDevice(params as Dictionary<String, AnyObject>, forUser: self.uuid!, token: self.authToken!, successBlock: {() -> Void in
                // do nothing
                print("[LoginManager registerDevice] posted device ok")
            }, errorBlock: {(error: Error!) in
                
            })
        }
    }
    
    
    class func dataToHex(_ data: Data) -> String {
        var str: String = String()
        let p = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
        let len = data.count
        
        for i in 0..<len {
            str += String(format: "%02.2X", p[i])
        }
        return str
    }
 
    
}

enum XCBLoginManagerUserDefaults: String {
    
    case UserIdKey = "com.xicaibao.user.uuid"
    case UserAuthToken = "com.xicaibao.user.authtoken"
    case UserTel = "com.xicaibao.user.tel"
}


