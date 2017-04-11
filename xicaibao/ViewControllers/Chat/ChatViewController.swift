//
//  ChatViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController {

    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let chatTableViewCellNibName = "ChatTableViewCell"
    let chatTableViewCellID = "chatCellTableViewCellIdentifier"
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
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
    
    private func setupView() {
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 74
        
        // cell
        tableView.register(UINib(nibName: chatTableViewCellNibName, bundle: nil), forCellReuseIdentifier: chatTableViewCellID)
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChatSearch" {
            
            if let searchVC = segue.destination as? ContactSearchViewController {
                
                // 搜索已经添加的好友
            }
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
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCellID, for: indexPath)
        
        return cell
    }
}

extension ChatViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "ChatSearch", sender: "nil")
        
        return false
    }
}
