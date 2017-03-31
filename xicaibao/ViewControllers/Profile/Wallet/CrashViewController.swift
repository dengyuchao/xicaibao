//
//  CrashViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class CrashViewController: UIViewController {

    @IBOutlet weak var carshAmountTextField: UITextField!
    @IBOutlet weak var allCrashButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "提现"
        nextButton.layer.cornerRadius = nextButton.layer.bounds.height / 8
        allCrashButton.layer.cornerRadius = allCrashButton.layer.bounds.height / 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
