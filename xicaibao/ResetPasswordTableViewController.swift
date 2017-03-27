//
//  ResetPasswordTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/24.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ResetPasswordTableViewController: UITableViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var resetActivity: UIActivityIndicatorView!
    
    
    var countdownTimer: Timer?
    
    var onSuccess: ((_ tel: String, _ password: String) -> Void)?
    
    // MARK: 倒计时按钮
    var remainingSeconds: Int = 0 {
        willSet {
            codeButton.setTitle("倒计时\(newValue)秒", for: .normal)
            
            if newValue <= 0 {
                codeButton.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ResetPasswordTableViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                
                codeButton.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                codeButton.backgroundColor = UIColor.KTButtonColor()
            }
            
            codeButton.isEnabled = !newValue
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏底部按钮
        self.navigationController?.isToolbarHidden = true
    }
    
    private func setupView() {
        title = "重置密码"
        self.telTextField.delegate = self
        self.codeTextField.delegate = self
        self.passwordTextField.delegate = self
        
        resetActivity.isHidden = true
        iconImageView.layer.cornerRadius = iconImageView.layer.bounds.height / 2
        codeButton.layer.cornerRadius = codeButton.layer.bounds.height / 8
        sureButton.layer.cornerRadius = sureButton.layer.bounds.height / 8
    }
    
    // MARK: 倒计时按钮
    func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    private func resetIng() {
        sureButton.isHidden = true
        resetActivity.isHidden = false
        resetActivity.startAnimating()
    }
    
    private func continueReset() {
        sureButton.isHidden = false
        resetActivity.stopAnimating()
    }
    
    private func resetPassword(tel: String, code: String, password: String) {
        
        self.resetIng()
        
        LoginManager.defaultManager.resetPassword(tel: tel, password: password, code: code, successBlock: { (user) in
            
            guard let onSuccess = self.onSuccess else { return }
            onSuccess(tel, password)
            
            self.navigationController!.popViewController(animated: true)
            
        }) { (error) in
            
            self.continueReset()
            
            let alertController = UIAlertController(title: "", message: "重置密码失败，请再试一次", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            
            print("[ResetPasswordTableViewController resetPassword]\(error.localizedDescription)")
        }
    }
    
    // actions
    // 发送验证
    @IBAction func didSendVerifCode(_ sender: UIButton) {
        
        guard let tel = self.telTextField.text else {
            
            // 验证电话号码
            let alertController = UIAlertController(title: "电话号码错误", message: "请重新输入电话号码", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            })
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            sender.setTitle("再次获取", for: .normal)
            return
        }
        
        let method = SMSGetCodeMethodSMS
        let zone = "86"
        
        SMSSDK.getVerificationCode(by: method, phoneNumber: tel, zone: zone, customIdentifier: "") { (error) in
            
            if error != nil {
                let errorTitle = NSLocalizedString("获取验证码失败", comment: "")
                let errorMessage = "获取验证码失败, 请稍后再试"
                let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                })
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
                sender.setTitle("再次获取", for: .normal)
            } else {
                print("[SignupTableViewController didSendVerifCode] 获取验证码成功")
                // set code button
                self.isCounting = true
            }
            
        }
    }
    
    // sure action
    @IBAction func sureAction(_ sender: UIButton) {
        guard let tel = self.telTextField.text else { return }
        guard let code = self.codeTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        SMSSDK.commitVerificationCode(code, phoneNumber: tel, zone: "86") { (userInfo, error) in
            
            if error == nil {
                print("[SignupTableViewController didSignupAction] verify OK")
                
                // API请求重置密码
                self.resetPassword(tel: tel, code: code, password: password)
                
            } else {
                
                print("[SignupTableViewController didSignupAction] verify FAIL, tel:\(tel), verif:\(code)")
                
                self.sureButton.isEnabled = false
                
                let alertController = UIAlertController(title: "验证码错误", message: "请重新输入验证码", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler:nil)
                
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension ResetPasswordTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            telTextField.becomeFirstResponder()
        
        case 1:
            codeTextField.becomeFirstResponder()
        case 2:
            passwordTextField.becomeFirstResponder()
            
        default:
            break
        }
    }
}

extension ResetPasswordTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == telTextField {
            codeTextField.becomeFirstResponder()
        }
        
        if textField == codeTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}
