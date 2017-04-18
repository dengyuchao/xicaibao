//
//  InitiateChatTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/5.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class CreateGroupTableViewController: BaseTableViewController {
    
    @IBOutlet weak var sureButton: UIBarButtonItem!
    
    var friends: [User] = [User]()
    var addGroupMembers: [User]?
    var selectIndexPath: IndexPath?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupEmptyViewModel()
        self.getContacts()
    }
    
    private func setupView() {
        // 设置tableview 允许多选
        self.tableView.allowsMultipleSelection = true
        self.tableView.isEditing = true
        self.tableView.rowHeight = 52.0
        
        self.sureButton.isEnabled = false
    }
    
    private func setupEmptyViewModel() {
        emptyViewModel = EmptyViewModel(alert: "您还没有好友呢", prompt: "快去添加好友吧")
    }
    
    // 获取通讯录好友
    private func getContacts() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getContacts(forUser: uuid, token: token, successBlock: { (friends) in
            self.friends = friends
            
        }) { (error) in
            print("[CreateGroupTableViewController getContacts]\(error.localizedDescription)")
        }
    }}

extension CreateGroupTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "initCell", for: indexPath)
//        if let name = self.friends[indexPath.row].nickName {
//            cell.textLabel?.text = name
//        } else {
//            cell.textLabel?.text = self.friends[indexPath.row].userName
//        }
//        
//        let placeholderImage = UIImage(named: "tongxunlu_touxiang")
//        cell.imageView?.layer.masksToBounds = true
//        cell.imageView?.layer.cornerRadius = (cell.imageView?.layer.bounds.height)! / 2
//        
//        if let imageUrl = self.friends[indexPath.row].imageUrl {
//            cell.imageView?.af_setImage(withURL: URL(string: imageUrl)!)
//        } else {
//            cell.imageView?.image = placeholderImage
//        }
        
        return cell
    }
    
    
    // 设置多选样式
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle(rawValue: UITableViewCellEditingStyle.insert.rawValue | UITableViewCellEditingStyle.delete.rawValue)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

