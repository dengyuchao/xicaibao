//
//  SendMailHelper.swift
//  xicaibao
//
//  Created by impressly on 2017/3/30.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
import MessageUI

class SendMailHelper: NSObject {
    
    class func createMFMailComposeViewController(uuid: String) -> MFMailComposeViewController {
        
        let currentDevice = UIDevice.current
        let strSystemName = currentDevice.systemName    //设备运行系统
        let strSystemVersion = currentDevice.systemVersion //当前系统版本
        let key = "CFBundleShortVersionString"
        let currentVersion = Bundle.main.infoDictionary![key] as! String
        let messageBody = "联系方式(Tel)：\n联系方式(QQ)：\n\n问题描述：\n\n\n\n喜财宝App 版本信息：\n[PopSpaces \(currentVersion), \(strSystemName), \(strSystemVersion),  \(uuid)]"
        
        let mailPicker = MFMailComposeViewController()
        
        //收件人
        mailPicker.setToRecipients([AppSecrets.kSetToRecipients])
        
        //邮件主题
        mailPicker.setSubject("[\(currentVersion) - ] 意见反馈")
        
        //邮件正文
        mailPicker.setMessageBody(messageBody, isHTML: false)
        
        return mailPicker
    }
    
    class func alertFromMFMailComposeResult(result: MFMailComposeResult) -> String {
        
        var alert: String?
        
        switch(result) {
        case .cancelled:
            alert = "取消发送意见反馈"
        case .saved:
            alert = "保存到草稿"
        case .sent:
            alert = "发送反馈成功"
        case .failed:
            alert = "发送反馈失败"
        }
        return alert!
    }
}
