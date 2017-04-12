//
//  BaseViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    fileprivate var isHiddenStateBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStatusBarHidden(_ isHidden: Bool) {
        isHiddenStateBar = isHidden
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden : Bool {
        return isHiddenStateBar
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

