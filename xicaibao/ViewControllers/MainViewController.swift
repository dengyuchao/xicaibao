//
//  ViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert() {
        let alertController = UIAlertController(title: "温馨提示", message: "功能暂未开放，敬请期待", preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction = UIAlertAction(title: "好", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
        })
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController == self.viewControllers?[0] {
            self.alert()
        }
        
        if viewController == self.viewControllers?[1] {
            print(2)
        }
        
        if viewController == self.viewControllers?[2] {
            print(3)
        }
        
        if viewController == self.viewControllers?[3] {
            print(4)
        }
        
        if viewController == self.viewControllers?[4] {
            print(5)
        }
    }
}

