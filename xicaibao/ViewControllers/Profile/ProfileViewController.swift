//
//  ProfileViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
import AlamofireImage
import MessageUI

class ProfileTableViewController: UITableViewController{
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 每次重新从服务器抓取最新的数据，同步最新修改
        self.getUser()
        self.setUserInfo()
    }
    
    private func setupView() {
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        tableView.tableFooterView = UIView()
        photoImageView.layer.cornerRadius = photoImageView.layer.bounds.height / 2
    }

    // get user
    private func getUser() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        ApiManager().getProfile(uuid, token: token, successBlock: { (user) in
            
            self.user = user
            
        }) { (error) in
            print("[ProfileTableViewController getUser]\(error.localizedDescription)")
        }
    }
    
    // 显示用户信息
    private func setUserInfo() {
        // 占位图
        let placeholderImage = UIImage(named: "wode_touxiang")
        
        if self.user == nil {
            
            photoImageView.image = placeholderImage
            
            nameLabel.text = ""
        } else {
            
            nameLabel.text = self.user?.userName
            if self.user?.imageUrl != nil {
                let imageUrl = URL(string: (self.user?.imageUrl)!)
                photoImageView.af_setImage(withURL: imageUrl!)
            } else {
                photoImageView.image = placeholderImage
            }
        }
    }
    
    
    // 意见反馈，发送邮件
    public func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            
            guard let uuid = LoginManager.defaultManager.uuid else {
                return
            }
            let mailPicker = SendMailHelper.createMFMailComposeViewController(uuid: uuid)
            mailPicker.mailComposeDelegate = self
            present(mailPicker, animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: "提示", message: "您还没有设置登录邮箱", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            })
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userInfoVC" {
            if let userInfoVC = segue.destination as? UserInfoTableViewController {
                guard let user = self.user else { return }
                userInfoVC.user = user
            }
        }
        
        if segue.identifier == "accountVC" {
            if let accountVC = segue.destination as? AccountSettingTableViewController {
                accountVC.user = self.user
            }
        }
    }
}

extension ProfileTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 创建&&编辑名片
        if indexPath.section == 2 && indexPath.row == 0 {
//            if self.user?.card == nil {
//                
//            }
            
            // 创建名片
            let storyBoard = UIStoryboard(name: "CreateCard", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "idCreate") as! CreateCardTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            
//            // 编辑名片
//            let storyBoard = UIStoryboard(name: "CreateCard", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "idEdit") as! EditCardTableViewController
//            vc.card = self.user?.card
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 意见反馈
        if indexPath.section == 3 && indexPath.row == 0 {
            self.sendEmail()
        }
    }
}

extension ProfileTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        let alert = SendMailHelper.alertFromMFMailComposeResult(result: result)
        controller.dismiss(animated: true) { () -> Void in
            print(alert)
        }
    }
}
