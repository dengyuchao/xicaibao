//
//  ProfileViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
import AlamofireImage

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
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userInfoVC" {
            if let userInfoVC = segue.destination as? UserInfoTableViewController {
                guard let user = self.user else { return }
                userInfoVC.user = user
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
}
