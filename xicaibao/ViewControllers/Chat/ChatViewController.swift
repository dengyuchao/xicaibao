//
//  ChatViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

struct ChatRoomCellData {
    var chatRoom: ChatRoom? // 用于传递到 ChatMessagesVC
    var avatarUrl: String?  // 头像
    var chatRoomName: String?   // 对方 Name
    var unreadCount: Int?   // 未读消息数量
    
    // 最近信息
    func message() -> String? {
        return chatRoom?.lastMessage()?.message
    }
    
    // 最近信息日期
    func messageDate() -> Date? {
        return chatRoom?.lastMessage()?.createdAt as Date?
    }
}

extension ChatRoom {
    
    // get counterparty of chatroom
    // @params
    // me: user uuid
    // @returns tuple of (username: String, avatarUrl: String) of counterparty
    func counterparty(_ me: String) -> (username: String, avatarUrl: String?) {
        for user in users {
            if user.uuid == me {
                continue
            }
            
            let username = user.userName ?? "对方聊天"
            let avatarUrl = user.imageUrl
            
            return (username, avatarUrl)
        }
        return ("对方聊天", nil)
    }
    
    func toCellData(forUser me: String) -> ChatRoomCellData {
        let (username, avatarUrl) = self.counterparty(me)
        
        // 生成 chatRoomCellData 用于 cell 显示用
        let chatRoomCellData = ChatRoomCellData(chatRoom: self, avatarUrl: avatarUrl, chatRoomName: username, unreadCount: self.unreadCount)
        
        return chatRoomCellData
    }
}


class ChatViewController: BaseTableViewController {

    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let chatTableViewCellNibName = "ChatTableViewCell"
    let chatTableViewCellID = "chatCellTableViewCellIdentifier"
    
    var chatRoomCellDataList: [ChatRoomCellData] = []
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupEmptyViewModel()
        self.getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        // MARK: 判断使用是否登录,如果没有登录，先弹出登录界面
        LoginManager.defaultManager.checkForLogin(target: self, onSuccess: {
            
        }) {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 获取数据
        self.getRecentChatRooms()
    }
    
    private func setupView() {
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 66
        
        // cell
        tableView.register(UINib(nibName: chatTableViewCellNibName, bundle: nil), forCellReuseIdentifier: chatTableViewCellID)
    }
    
    private func setupEmptyViewModel() {
        emptyViewModel = EmptyViewModel(alert: "暂时没有会话", prompt: "点击右上角发起聊天")
    }
    
    
    // 获取当前user
    func getUser() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getProfile(uuid, token: token, successBlock: { (user) in
            self.user = user
        }) { (error) in
            
            print("[ContactSearchViewController getUser] getProfile failed: \(error.localizedDescription)")
        }
    }
    
    // 获取聊天列表
    private func getRecentChatRooms() {
        guard let uuid = LoginManager.defaultManager.uuid
            else { return }
        guard let token = LoginManager.defaultManager.authToken
            else { return }
        
        ApiManager().getChatRooms(forUser: uuid, token: token, successBlock: { (chatRooms: [ChatRoom]) in
            
            self.setupChatRoomCellData(chatRooms)
            self.refresh()
            
        }) { (error) in
            print("[ChatViewController getRecentChatRooms] \(error.localizedDescription)")
        }
    }
    
    // maintain array of ChatRoomData for use in view cells
    private func setupChatRoomCellData(_ chatRooms: [ChatRoom]) {
        
        guard let uuid = LoginManager.defaultManager.uuid
            else { return }
        
        self.chatRoomCellDataList = []
        
        for chatRoom in chatRooms {
            let chatRoomCellData = chatRoom.toCellData(forUser: uuid)
            self.chatRoomCellDataList.append(chatRoomCellData)
        }
    }
    
    private func refresh() {
        
        // sort by date
        self.chatRoomCellDataList.sort(by: {(first, second) -> Bool in
            guard let firstDate = first.messageDate() else {
                return true // if nil push to top
            }
            guard let secondDate = second.messageDate() else {
                return false // if nil push second to top
            }
            return firstDate.isGreaterThanDate(secondDate) // descending order
        })
        
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChatSearch" {
            
            if let searchVC = segue.destination as? ContactSearchViewController {
                
                // 搜索已经添加的好友
            }
        }
        
        if segue.identifier == "chatRoomVC" {
            guard let indexPath = sender as? IndexPath else { return }
            let chatRoomVC = segue.destination as! ChatRoomTableViewController
            
        }
    }
    
    
    // action 弹出菜单按钮
    @IBAction func addBtAction(_ sender: UIBarButtonItem) {
        
        var menuItems = [KxMenuItem]()
        
        // TODO: 添加对应的 target action
        let chatMenuItem = KxMenuItem.init("发起群聊", image: UIImage(named: "startchat_icon"), target: self, action: #selector(ChatViewController.pushChat))
        
        let groupMenuItem = KxMenuItem.init("创建群组", image: UIImage(named: "creategroup_icon"), target: self, action: #selector(ChatViewController.createGroup))
        let addFriendMenuItem = KxMenuItem.init("添加好友", image: UIImage(named: "addfriend_icon"), target: self, action: #selector(ChatViewController.addFriend))
        
        menuItems.append(chatMenuItem!)
        menuItems.append(groupMenuItem!)
        menuItems.append(addFriendMenuItem!)
        
        // 设置菜单frame
        let view = self.addButtonItem.value(forKey: "view") as! UIView
        var targetFrame = view.frame
        targetFrame.origin.y += 15
        
        KxMenu.setTitleFont(UIFont.systemFont(ofSize: 17))
        KxMenu.setTintColor(UIColor.black)
        KxMenu.show(in: self.view.window, from: targetFrame, menuItems: menuItems)
    }
    
    // actions
    
    // 发起聊天
    public func pushChat() {
        
        let storyboard = UIStoryboard.init(name: "InitiateChat", bundle: nil)
        let initiateChatVC = storyboard.instantiateViewController(withIdentifier: "idInitiateChat") as! InitiateChatTableViewController
        initiateChatVC.title = "发起聊天"
        
        // TODO:传值
        self.navigationController?.pushViewController(initiateChatVC, animated: true)
    }
    
    // 创建群组
    public func createGroup() {
        
        let storyboard = UIStoryboard.init(name: "InitiateChat", bundle: nil)
        let initiateChatVC = storyboard.instantiateViewController(withIdentifier: "idInitiateChat") as! InitiateChatTableViewController
        initiateChatVC.title = "选择联系人"
        
        // TODO:传值
        self.navigationController?.pushViewController(initiateChatVC, animated: true)
    }
    
    // 添加好友
    public func addFriend() {
        let storyboard = UIStoryboard.init(name: "AddFriend", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "idAddFriend") as! AddFriendTableViewController
        // TODO:传值
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChatViewController {
    
     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatRoomCellDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCellID, for: indexPath) as! ChatTableViewCell
        cell.chatRoomCellData = chatRoomCellDataList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "chatRoomVC", sender: indexPath)
    }
}

extension ChatViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "ChatSearch", sender: "nil")
        
        return false
    }
}
