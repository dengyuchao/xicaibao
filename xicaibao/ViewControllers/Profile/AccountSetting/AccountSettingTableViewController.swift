//
//  AccountSettingTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/29.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit


class AccountSettingTableViewController: UITableViewController {
    
    @IBOutlet weak var cacheLabel: UILabel!
    @IBOutlet weak var clearActivity: UIActivityIndicatorView!
    
    var user: User?
    var totalSize: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号设置"
        cacheLabel.text = caculateCache()
    }
    
    //计算缓存大小
    func caculateCache() ->String{
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first
        
        let fileManager = FileManager.default
    
        var total:Float = 0
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            if childrenPath != nil {
                for path in childrenPath!{
                    
                    let childPath = basePath!.appending("/").appending(path)
                    do{
                        
                        let attr = try fileManager.attributesOfItem(atPath: childPath)
                        let fileSize: Float = attr[FileAttributeKey.size] as! Float
                        total += fileSize
                        
                    } catch {
                        
                    }
                    
                }
            }
        }
        
        totalSize =  total / 1024.0 / 1024.0
        
        let cacheSize = String(format: "%.1f MB", totalSize) as String
        return cacheSize
    }
    
    //清除缓存
    public func clearCache() ->Bool {
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first
        
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath!{
                let cachePath = basePath?.appending("/").appending(childPath)
                do {
                    try fileManager.removeItem(atPath: cachePath!)
                } catch {
                    result = false
                }
            }  
        }  
        
        return result  
    }
    
    //跳转到应用的AppStore页面
    func gotoAppStore() {
        UIApplication.shared.openURL(NSURL(string: AppSecrets.kAppItunesURL)! as URL)
    }
}

extension AccountSettingTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 鼓励一下,AppStore评分
        if indexPath.section == 0 && indexPath.row == 2  {
            
            // 弹出消息框
            let alertController = UIAlertController(title: "觉得好用的话，给我个评价吧！",message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "暂不评价", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default,handler: { action in
                // TODO:
                // self.gotoAppStore()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        // 清除缓存
        if indexPath.section == 1 {
            //提示框
            let message = self.caculateCache()
            let alert = UIAlertController(title: "清除缓存", message: message, preferredStyle:UIAlertControllerStyle.alert)
            let alertConfirm = UIAlertAction(title: "确定", style:UIAlertActionStyle.default) { (alertConfirm) ->Void in
                
                // 清除成功
                if self.clearCache() {
                    self.cacheLabel.text = "0.0 MB"
                    tableView.reloadData()
                }
            }
            alert.addAction(alertConfirm)
            
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancle)
            
            present(alert, animated: true)
        }
        
        // 退出登录
        if indexPath.section == 2 {
            
            let alert = UIAlertController(title: "", message: "您确定要退出此账号吗？", preferredStyle:UIAlertControllerStyle.alert)
            let alertConfirm = UIAlertAction(title: "确定", style:UIAlertActionStyle.default) { (alertConfirm) ->Void in
                
                LoginManager.defaultManager.logout()
                
                // 回到登录界面
                LoginManager.defaultManager.checkForLogin(target: self, onSuccess: { 
                    
                }, onCancel: { 
                    
                })
            }
            alert.addAction(alertConfirm)
            
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancle)
            
            present(alert, animated: true)
        }
    }
}


