//
//  RechargeTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class RechargeViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "充值"
        nextButton.layer.cornerRadius = nextButton.layer.bounds.height / 8
        
    }
}
