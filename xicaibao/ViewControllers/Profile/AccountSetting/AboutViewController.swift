//
//  AboutViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/30.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "关于喜财宝"
        let key = "CFBundleShortVersionString"
        
        let currentVersion = Bundle.main.infoDictionary![key] as! String
        currentVersionLabel.text = "当前版本：v\(currentVersion)"
        boderView.layer.borderWidth = 1
        boderView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
    }
}
