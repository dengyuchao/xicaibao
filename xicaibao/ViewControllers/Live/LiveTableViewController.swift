//
//  LiveTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class LiveTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

}
