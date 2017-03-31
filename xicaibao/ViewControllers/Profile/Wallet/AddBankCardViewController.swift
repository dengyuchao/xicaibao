//
//  AddBankCardViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class AddBankCardViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "添加银行卡"
        nextButton.layer.cornerRadius = nextButton.layer.bounds.height / 8
    }

}
