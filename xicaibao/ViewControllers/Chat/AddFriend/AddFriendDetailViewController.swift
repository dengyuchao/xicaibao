//
//  AddFriendDetailTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/7.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class AddFriendDetailViewController: UIViewController {
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    var friend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "添加好友"
        
        addButton.layer.cornerRadius = addButton.layer.bounds.height / 8
        friendImageView.layer.cornerRadius = friendImageView.layer.bounds.height / 2
        
        guard let user = self.friend else { return }
        friendNameLabel.text = user.userName
        if let url = user.imageUrl {
            friendImageView.af_setImage(withURL: URL(string: url)!)
        } else {
            let placeholderImage = UIImage(named: "tongxunlu_touxiang")
            friendImageView.image = placeholderImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func addFriendBtAction(_ sender: UIButton) {
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        // API请求
        guard let friend = self.friend else { return }
        ApiManager().postAddFriend(friend: friend, forUser: uuid, token: token, successBlock: { (friend) in
            // alert
            var  alertController: UIAlertController = UIAlertController()
            if friend.uuid == uuid {
                alertController = UIAlertController(title: "", message: "您不能将自己添加到通讯录", preferredStyle: UIAlertControllerStyle.alert)
            } else {
                alertController = UIAlertController(title: "", message: "请求已发送", preferredStyle: UIAlertControllerStyle.alert)
            }
            
            let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            
        }) { (error) in
            print("[AddFriendDetailViewController addFriendBtAction] addFriendFailed: \(error.localizedDescription)")
        }
    }
}
