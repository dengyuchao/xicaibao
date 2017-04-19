//
//  FriendDetailViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/10.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

protocol FriendDetailTableViewControllerDelegate: NSObjectProtocol {
    
    func didNickNameSave(nickName: String, indexPath: IndexPath)
    func didPostBolck(indexPath: IndexPath)
}


class FriendDetailTableViewController: UITableViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initChatBt: UIButton!
    
    @IBOutlet weak var initChatCell: UITableViewCell!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var NickNameLabel: UILabel!
    
    var friend: User?
    var indexPath: IndexPath?
    weak var delegate: FriendDetailTableViewControllerDelegate?
    
    var chatRoom: ChatRoom?
    var chatRoomCellData: ChatRoomCellData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
    }
    
    private func  setupView() {
        
        tableView.tableFooterView = UIView()
        initChatBt.layer.cornerRadius = initChatBt.layer.bounds.height / 8
        imageView.layer.cornerRadius = imageView.layer.bounds.height / 2
        // 去掉分割线
        initChatCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, initChatCell.bounds.size.width)
        
        guard let friend = self.friend else { return }
        telLabel.text = friend.userTel
        if let nickName = friend.nickName {
            NickNameLabel.text = nickName
            nameLabel.text = friend.userName
        } else {
            nameLabel.text = friend.userName
            NickNameLabel.text = friend.userName
        }
        if let imageUrlString = friend.imageUrl {
            imageView.af_setImage(withURL: URL(string: imageUrlString)!)
        } else {
            let placeholderImage = UIImage(named: "tongxunlu_touxiang")
            imageView.image = placeholderImage
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
       return 21.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setNickNameVC" {
            if let setNickNameVC = segue.destination as? SetNickNameTableViewController {
                guard let friend = self.friend else { return }
                setNickNameVC.nickName = friend.nickName
                setNickNameVC.delegate = self
            }
        }
        
        // 进入到聊天
        if segue.identifier == "chatRoomMSVC" {
            let chatRoomMessageVC = segue.destination as! ChatRoomMessageViewController
            if let chatRoomName = chatRoomCellData?.chatRoomName {
                chatRoomMessageVC.title = chatRoomName
            }
            
            if let chatRoom = chatRoomCellData?.chatRoom {
                chatRoomMessageVC.chatRoom = chatRoom
            }
            
            if let avatarUrl = chatRoomCellData?.avatarUrl {
                chatRoomMessageVC.incomingAvatarUrl = avatarUrl
            }

        }
    }

    @IBAction func moreAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController()
        let sureAction = UIAlertAction(title: "加入黑名单", style: .default) { (UIAlertAction) in
            // API请求加入黑名单
            guard let friend = self.friend else { return }
            guard let uuid = LoginManager.defaultManager.uuid else { return }
            guard let token = LoginManager.defaultManager.authToken else { return }
            
            ApiManager().postBlock(friendId: friend.uuid, uuid: uuid, token: token, successBlock: {
                print("[FriendDetailTableViewController moreAction] postBlockSuccess")
                
                guard let indexPath = self.indexPath else { return }
                self.delegate?.didPostBolck(indexPath: indexPath)
                
            }, errorBlock: { (error) in
                
                print("[FriendDetailTableViewController moreAction] postBlock failed: \(error.localizedDescription)")
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 发起会话
    @IBAction func initChatAction(_ sender: UIButton) {
        // 创建聊天室
        chatRoom = ChatRoom(key: nil)
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        chatRoomCellData = chatRoom?.toCellData(forUser: uuid)
    }
    
}

extension FriendDetailTableViewController: SetNickNameTableViewControllerDelegate {
    
    func editNickNameSave(nickName: String) {
        self.NickNameLabel.text = nickName
        
        guard let friend = self.friend else { return }
        friend.nickName = nickName
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        // API请求
        ApiManager().patchFriendNickName(friend, uuid: uuid, token: token, successBlock: { (friend) in
            print("[FriendDetailTableViewController patchFriendNickName] success")
            
            guard let indexPath = self.indexPath else { return }
            self.delegate?.didNickNameSave(nickName: nickName, indexPath: indexPath)
            
        }) { (error) in
            
            print("[SetNickNameTableViewController patchFriendNickName] \(error.localizedDescription)")
        }

    }
}
