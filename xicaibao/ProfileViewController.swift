//
//  ProfileViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.tableFooterView = UIView()
        
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
