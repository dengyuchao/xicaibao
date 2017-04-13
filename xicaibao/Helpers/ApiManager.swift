//
//  ApiManager.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation
import Alamofire

// API 请求管理类
class ApiManager {
    var apiUrl = AppSecrets.API_URL
    
    init() {}
    
    // 登录 电话、密码
    func postLogin(tel: String, password:String,
                   successBlock: @escaping (_ user: User, _ authToken: String) ->Void,errorBlock: @escaping (_ error:Error?) -> Void){
        
        let params = ["tel": tel, "password": password]
        let url = URL(string: "\(self.apiUrl)/xcb/login/")!
        let headers = ApiManager.headersJsonOnly()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                errorBlock(error as Error)
                return
            }
            
            // parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                do {
                    
                    // 字典 data 里面存的才是数据
                    var data: Dictionary<String, AnyObject>?
                    for js in jsonObj {
                        
                        if js.key == "data" {
                            data = js.value as? Dictionary<String, AnyObject>
                        }
                    }
                    
                    let user = try User.fromJson(json: data!)
                    
                    successBlock(user, user.authToken)
                    
                } catch let error as Error {
                    errorBlock(error)
                }
            } else {
                print("[ApiManager postLogin] success, but response was not Dictionary<String, AnyObject>")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
        
    }
    
    // 注册 用户名、电话、密码
    func postSignup(name: String, tel: String, code:String, password: String,successBlock: @escaping (_ user: User, _ authToken: String) -> Void,errorBlock: @escaping (_ error:Error) -> Void) {
        
        // make user params
        let params = ["username": name, "user_tel": tel, "code": code,"password": password]
        
        postSignupParams(withParams: params as Dictionary<String, AnyObject> , successBlock: {(user, authToken) in
            
            print("[ApiManager postSignup] signup OK, user: \(user)")
            successBlock(user, authToken)
            
        }, errorBlock: {(error) in
            print("[ApiManager postSignup] success, but response was not Dictionary<String, AnyObject>")
            errorBlock(error)
        })
        
    }
    
    private func postSignupParams(withParams params: Dictionary<String, AnyObject>,successBlock: @escaping (_ user: User, _ authToken: String) -> Void,errorBlock: @escaping (_ error:Error) -> Void) {
        
        let url = URL(string: "\(self.apiUrl)/xcb/signup")!
        
        let headers = ApiManager.headersJsonOnly()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            // manually catch error status
//            let validStatusCodes = 200..<300
//            let responseStatus = response.response?.statusCode ?? -1
//            if !validStatusCodes.contains(responseStatus) {
//                
//                // parse json for error message
//                if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
//                    // show first error
//                    let title = jsonObj.keys.first ?? ""
//                    let errors = jsonObj[title] as! [String]
//                    let message = errors[0]  // error messages returns as array
//                    
//                    let userInfo = ModelErrorManager.localizedUserInfo("[\(title)] \(message)", reason: "", recovery: "")
//                    let error = NSError(domain: "RegistrationError", code: responseStatus, userInfo: userInfo)
//                    errorBlock(error)
//                    return
//                } else {
//                    // fallback with General Error, response is not valid status code, and includes network error.
//                    let error = ModelErrorManager.errorWithType(ModelDataError.generalError)
//                    errorBlock(error)
//                    return
//                }
//            }
            
            
            if let error = response.result.error {
                errorBlock(error as Error)
                return
            }
            
            // parse JSON response as user data
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                do {
                    
                    // 字典 data 里面存的才是数据
                    var data: Dictionary<String, AnyObject>?
                    for js in jsonObj {
                        
                        if js.key == "data" {
                            data = js.value as? Dictionary<String, AnyObject>
                        }
                    }
                    
                    let user = try User.fromJson(json: data!)
                    successBlock(user, user.authToken)
                    return
                    
                } catch let error as Error {
                    errorBlock(error)
                    return
                }
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
                return
            }
        }
    }
    
    // 重置密码
    func resetPassword(_ tel: String, password: String, code: String,successBlock: @escaping (_ user: User, _ authToken: String) -> Void,errorBlock: @escaping (_ error: Error?) -> Void) {
        
        let params = ["user_tel": tel, "password": password, "code": code]
        let url = URL(string: "\(self.apiUrl)/xcb/resetPassword")!
        let headers = ApiManager.headersJsonOnly()
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                errorBlock(error)
                return
            }
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                do {
                    // 字典 data 里面存的才是数据
                    var data: Dictionary<String, AnyObject>?
                    for js in jsonObj {
                        
                        if js.key == "data" {
                            data = js.value as? Dictionary<String, AnyObject>
                        }
                    }
                    
                    let user = try User.fromJson(json: data!)
                    successBlock(user, user.authToken)
                    
                } catch let error as Error{
                    errorBlock(error)
                }
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
        
    }
    
    // MARK: User Device
    // POST /devices
    
    func postDevice(_ params: Dictionary<String, AnyObject>, forUser uuid: String, token: String, successBlock: @escaping (() -> Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let request_url = URL(string: "\(self.apiUrl)/xcb/devices/")!
        let headers = ApiManager.headers(uuid, token: token)
        
        print("[ApiManager postDevice] requestURL: \(request_url), params: \(params), headers: \(headers)")
        Alamofire.request(request_url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if let error = response.result.error {
                errorBlock(error as Error)
                return
            }
            print("[ApiManager postDevice] Device OK, JSON: " + response.result.debugDescription)
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                print("[Device POST succcess]/Device: \(jsonObj.description)")
                
                successBlock()
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager postDevice] Error: " + error.localizedDescription)
                errorBlock(error)
            }
        }
    }
    
    // MARK:获取用户信息
    // GET /profile
    func getProfile(_ uuid: String, token: String, successBlock: @escaping ((_ user: User) -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        let requestURL = URL(string: "\(self.apiUrl)/xcb/profile/")!
        let headers = ApiManager.headers(uuid, token: token)
        
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager getProfile] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let user = try! User.fromJson(json: data!)
                successBlock(user)
                
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager getProfile] response json error: " + error.localizedDescription)
                errorBlock(error)
            }
            
        }
    }
    
    
    // 更新用户信息
    // MARK: PATCH/ profile
    func patchProfile(_ user: User, uuid: String, token: String, successBlock: @escaping ((_ user: User) -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/profile/update")!
        
        let headers = ApiManager.headers(uuid, token: token)
        let params = user.toJson()
        
        Alamofire.request(requestURL, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager patchProfile] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let user = try! User.fromJson(json: data!)
                successBlock(user)
                
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager patchProfile] response json error: " + error.localizedDescription)
                errorBlock(error)
            }
            
        }
    }

    
    
    // 上传照片到服务器
    func patchProfilePhoto(_ photoImage: Data, uuid: String, token: String, successBlock: @escaping ((_ user: User) -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/profile/photo")!
        let headers = ApiManager.headersForm(uuid, token: token)
        
        
        let formDataBlock: (MultipartFormData) -> Void = {multipartFormData in
            // append imageData
            multipartFormData.append(photoImage, withName: "user[avatar]", fileName: "avatar.jpg", mimeType: "image/jpeg")
        }
        
        
        let encodingBlock: (SessionManager.MultipartFormDataEncodingResult) -> Void = {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let error = response.result.error {
                        errorBlock(error as Error)
                        return
                    }
                    
                    if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                        
                        // 字典 data 里面存的才是数据
                        var data: Dictionary<String, AnyObject>?
                        for js in jsonObj {
                            
                            if js.key == "data" {
                                data = js.value as? Dictionary<String, AnyObject>
                            }
                        }
                        
                        let user = try! User.fromJson(json: data!)
                        successBlock(user)
                        
                    } else {
                        let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                        print("[ApiManager patchProfilePhoto] response json error: " + error.localizedDescription)
                        errorBlock(error)
                    }
                }
            case .failure(let encodingError):
                print("[ApiManager patchProfilePhoto] encoding error: \(encodingError)")
                let error = ModelErrorManager.errorWithType(ModelDataError.entityNotValid)
                errorBlock(error)
            }
            
        }
        
        Alamofire.upload(multipartFormData: formDataBlock, to: requestURL, method: .patch, headers: headers, encodingCompletion: encodingBlock)
    }
    
    
    // 创建名片post
    func postCard(card: Card, forUser uuid: String, token: String, successBlock: @escaping ((_ card: Card)->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/createCard")!
        // authentication headers
        let headers = ApiManager.headers(uuid, token: token)
        
        let params: Dictionary<String, AnyObject> = card.toJson()
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager postCard] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let card = try! Card.fromJson(json: data!)
                successBlock(card)
                
            } else {
                print("[ApiManager postCard] response json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 更新名片信息  patch
    func patchCard(card: Card, forUser uuid: String, token: String, successBlock: @escaping ((_ card: Card)->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/card/card.key")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        let params: Dictionary<String, AnyObject> = card.toJson()
        
        Alamofire.request(requestURL, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager patchCard] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let card = try! Card.fromJson(json: data!)
                successBlock(card)
                
            } else {
                print("[ApiManager patchCard] resonse json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 获取名片列表
    func getCards(forUser uuid: String, token: String, successBlock: @escaping ((_ cards: [Card])->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/getCards")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        Alamofire.request(requestURL, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager getCards] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: [Dictionary<String, AnyObject>?]? = nil
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = (js.value as? [Dictionary<String, AnyObject>])!
                    }
                }
                
                var cards: [Card] = [Card]()
                for obj in data! {
                    let card = try! Card.fromJson(json: obj!)
                    cards.append(card)
                }
                successBlock(cards)
                
            } else {
                print("[ApiManager getCards] resonse json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 搜索好友
    func searchNewFriend(tel: String?, forUser uuid: String, token: String, successBlock: @escaping ((_ friend: User)->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/searchNewFriend")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        let params = ["tel": tel as AnyObject]
        
        Alamofire.request(requestURL, method: .get, parameters: params as Dictionary<String, AnyObject>, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager searchNewFriend] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let friend = try! User.fromJson(json: data!)
                successBlock(friend)
                
            } else {
                print("[ApiManager searchNewFriend] resonse json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 添加好友
    func postAddFriend(friend: User, forUser uuid: String, token: String, successBlock: @escaping ((_ friend: User)->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/addFriend")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        let params: Dictionary<String, AnyObject> = friend.toJson()
        
        Alamofire.request(requestURL, method: .post, parameters: params , encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager postAddFriend] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let friend = try! User.fromJson(json: data!)
                successBlock(friend)
                
            } else {
                print("[ApiManager postAddFriend] resonse json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 获取通讯录列表
    func getContacts(forUser uuid: String, token: String, successBlock: @escaping ((_ friends: [User])->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/getContacts")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        Alamofire.request(requestURL, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager getContacts] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: [Dictionary<String, AnyObject>?]? = nil
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = (js.value as? [Dictionary<String, AnyObject>])!
                    }
                }
                
                var friends: [User] = [User]()
                for obj in data! {
                    let friend = try! User.fromJson(json: obj!)
                    friends.append(friend)
                }
                successBlock(friends)
                
            } else {
                print("[ApiManager getContacts] resonse json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 更新好友备注名
    func patchFriendNickName(_ friend: User, uuid: String, token: String, successBlock: @escaping ((_ friend: User) -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/friendNickname/update")!
        
        let headers = ApiManager.headers(uuid, token: token)
        let params = friend.toJson()
        
        Alamofire.request(requestURL, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager patchFriendNickName] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            if let jsonObj = response.result.value as? Dictionary<String, AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: Dictionary<String, AnyObject>?
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = js.value as? Dictionary<String, AnyObject>
                    }
                }
                
                let friend = try! User.fromJson(json: data!)
                successBlock(friend)
                
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager patchFriendNickName] response json error: " + error.localizedDescription)
                errorBlock(error)
            }
        }
    }
    
    // 加入黑名单
    func postBlock(friendId: String,uuid: String, token: String, successBlock: @escaping (() -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/postBlock")!
        
        let headers = ApiManager.headers(uuid, token: token)
        let params = ["friend_id": friendId]
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager postBlock] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
                successBlock()
        }
    }
    
    // 搜索联系人
    func searchContact(searchString: String, forUser uuid: String, token: String, successBlock: @escaping ((_ friends: [User])->Void), errorBlock: @escaping (_ error: Error) -> Void) {
        
        let requestURL = URL(string: "\(self.apiUrl)/xcb/searchContact")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        let params = ["search_string": searchString]
        
        Alamofire.request(requestURL, method: .get, parameters: params , encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager searchContact] error: \(error.localizedDescription)")
                errorBlock(error as Error)
                return
            }
            
            //parse JSON response
            if let jsonObj = response.result.value as? Dictionary<String,AnyObject> {
                
                // 字典 data 里面存的才是数据
                var data: [Dictionary<String, AnyObject>?]? = nil
                for js in jsonObj {
                    
                    if js.key == "data" {
                        data = (js.value as? [Dictionary<String, AnyObject>])!
                    }
                }
                
                var friends: [User] = [User]()
                for obj in data! {
                    let friend = try! User.fromJson(json: obj!)
                    friends.append(friend)
                }
                successBlock(friends)
                
            } else {
                print("[ApiManager searchContact] resonse json error")
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                errorBlock(error)
            }
        }
    }
    
    // 获取会话列表
    func getChatRooms(forUser uuid: String, token: String, successBlock: @escaping ((_ chatRooms: [ChatRoom]) -> Void) , errorBlock: @escaping (_ error: Error) -> Void) {
        let requestURL = URL(string: "\(self.apiUrl)/xcb/chatRooms")!
        
        let headers = ApiManager.headers(uuid, token: token)
        
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if let error = response.result.error {
                print("[ApiManager getChatRooms] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            var chatRooms = [ChatRoom]()
            
            if let jsonArray = response.result.value as? [Dictionary<String, AnyObject>] {
                
                for jsonObj in jsonArray {
                    let chatRoom = try! ChatRoom.fromJson(json: jsonObj)
                    chatRooms.append(chatRoom)
                }
                successBlock(chatRooms)
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager getChatRooms] response json error: " + error.localizedDescription)
                errorBlock(error)
            }
        }
    }
    
    // 获取聊天消息
    func getChatMessages(_ page: Int?, forChatRoom chatRoomKey: String, forUser uuid: String, token: String, successBlock: @escaping ((_ chatMessages: [ChatMessage]) -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        let requestURL = URL(string: "\(self.apiUrl)/xcb/getChatMessages")!
        let headers = ApiManager.headers(uuid, token: token)
        
        // page params
        let params: Dictionary<String, AnyObject> = ["chat_room_id": chatRoomKey as AnyObject, "page": (page as AnyObject? ?? 1 as AnyObject)]
        Alamofire.request(requestURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager getChatMessages] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            var chatMessages = [ChatMessage]()
            
            if let jsonArray = response.result.value as? [Dictionary<String, AnyObject>] {
                
                for jsonObj in jsonArray {
                    let chatMessage = try! ChatMessage.fromJson(json: jsonObj)
                    chatMessages.append(chatMessage)
                }
                successBlock(chatMessages)
                
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager getChatMessages] response json error: " + error.localizedDescription)
                errorBlock(error)
            }
            
        }
    }
    
    // 发送聊天信息
    func postChatMessage(_ chatMessage: ChatMessage, chatRoom: ChatRoom, forUser uuid: String, token: String, successBlock: @escaping ((_ chatMessage: ChatMessage) -> Void), errorBlock: @escaping ((_ error: Error) -> Void)) {
        let requestURL = URL(string: "\(self.apiUrl)/xcb/postChatMessages")!
        let params: Dictionary<String, AnyObject> = [
            "chat_room_id": chatRoom.key as AnyObject,
            "chat_message": chatMessage.toJson() as AnyObject
        ]
        let headers = ApiManager.headers(uuid, token: token)
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            if let error = response.result.error {
                print("[ApiManager postChatMessage] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                
                let chatMessage = try! ChatMessage.fromJson(json: json)
                successBlock(chatMessage)
                
            } else {
                let error = ModelErrorManager.errorWithType(ModelDataError.jsonInvalid)
                print("[ApiManager postChatMessage] response json error: " + error.localizedDescription)
                errorBlock(error)
            }
        }
    }
    
    
    // GET /chat_rooms/:key/mark  通知服务器已读消息
    func markChatRoom(_ key: String, forUser uuid: String, token: String, successBlock: @escaping (() -> Void) , errorBlock: @escaping (_ error: Error) -> Void) {
        let requestURL = URL(string: "\(self.apiUrl)/xcb/chatRoomsRead")!
        let headers = ApiManager.headers(uuid, token: token)
        
        let params = ["chat_room_id": key]
        
        Alamofire.request(requestURL, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if let error = response.result.error {
                print("[ApiManager markChatRoom] Error: " + error.localizedDescription)
                errorBlock(error as Error)
                return
            }
            
            // no content
            successBlock()
        }
    }
}


extension ApiManager {
    
    class func headers(_ user: String, token: String) -> [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-API-USER": user,
            "X-API-TOKEN": token
        ]
    }
    
    class func headersForm(_ user: String, token: String) -> [String: String] {
        return [
            "Accept": "application/json",
            "X-API-USER": user,
            "X-API-TOKEN": token
        ]
    }
    
    class func headersJsonOnly() -> [String: String]{
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
}
