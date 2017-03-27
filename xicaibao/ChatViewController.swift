//
//  ChatViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: 判断使用是否登录,如果没有登录，先弹出登录界面
//        LoginManager.defaultManager.checkForLogin(target: self, onSuccess: { 
//            
//        }) { 
//            
//        }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
