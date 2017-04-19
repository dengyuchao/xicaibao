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
    var addGroupMembers: [User] = [User]() {
        didSet {
            self.buttonState()
        }
    }
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
        self.tableView.tableFooterView = UIView()
        
//        self.sureButton.isEnabled = false
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
    }
    
    // 确定按钮的状态
    func buttonState() {
        self.sureButton.isEnabled = self.addGroupMembers.count > 0
        if self.addGroupMembers.count > 0 {
            self.sureButton.title = "确定(\(self.addGroupMembers.count))"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "groupSettingVC" {
            if let groupSetVC = segue.destination as? GroupSettingViewController {
                if self.addGroupMembers.count > 0 {
                    groupSetVC.groups = self.addGroupMembers
                }
            }
        }
    }
    
    @IBAction func sureButtonAction(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "groupSettingVC", sender: nil)
    }
}



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
        
        // 选中添加到数组
        if self.friends.count > 0 {
            let user = self.friends[indexPath.row]
            self.addGroupMembers.append(user)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // 从选中中取消
        if (self.addGroupMembers.count) > 0 {
            self.addGroupMembers.remove(at: indexPath.row)
        }
        
    }
    
}

