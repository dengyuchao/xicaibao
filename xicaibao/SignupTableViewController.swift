//
//  SignupTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class SignupTableViewController: UITableViewController {
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupActivity: UIActivityIndicatorView!
    
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
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SignupTableViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
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
        self.setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏底部按钮
        self.navigationController?.isToolbarHidden = true
    }
    
    
    private func setupView() {
        title = "注册"
        
        self.nameTextField.delegate = self
        self.telTextField.delegate = self
        self.codeTextField.delegate = self
        self.passwordTextField.delegate = self
        
        iconImageView.layer.cornerRadius = iconImageView.layer.bounds.width / 2
        codeButton.layer.cornerRadius = codeButton.layer.bounds.height / 8
        signupButton.layer.cornerRadius = signupButton.layer.bounds.height / 8
        
        signupActivity.isHidden = true
    }
    
    
    // MARK: 倒计时按钮
    func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
    
    private func signingUp() {
        signupButton.isHidden = true
        signupActivity.isHidden = false
        signupActivity.startAnimating()
    }
    
    private func continueSignup() {
        signupButton.isHidden = false
        signupActivity.stopAnimating()
        
    }
    
   
    private func signup(name: String, tel: String, code: String, password: String) {
        
        signingUp()
        
        LoginManager.defaultManager.signup(name: name, tel: tel, code: code, password: password, onSuccess: { (user) in
            
            guard let onSuccess = self.onSuccess else { return }
            onSuccess(tel, password)

            self.navigationController!.popViewController(animated: true)
            
        }) { (error) in
            self.continueSignup()
            
            let alertController = UIAlertController(title: "", message: "登录失败，请再试一次", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            
            print("[SignupTableViewController signup]\(error.localizedDescription)")
        }
    }
    
    
    // actions  
    // 发送验证码
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
    
    // 注册
    @IBAction func didSignupAction(_ sender: UIButton) {
        guard let tel = self.telTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
        guard let code = self.codeTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        SMSSDK.commitVerificationCode(code, phoneNumber: tel, zone: "86") { (userInfo, error) in
            
            if error == nil {
                print("[SignupTableViewController didSignupAction] verify OK")
                
                // API请求登录
                self.signup(name: name, tel: tel, code: code, password: password)
                
            } else {
                
                print("[SignupTableViewController didSignupAction] verify FAIL, tel:\(tel), verif:\(code)")
                
                self.signupButton.isEnabled = true
                let alertController = UIAlertController(title: "验证码错误", message: "请重新输入验证码", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler:nil)
                
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
}

extension SignupTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            nameTextField.becomeFirstResponder()
        case 1:
            telTextField.becomeFirstResponder()
        case 2:
            codeTextField.becomeFirstResponder()
        case 3:
            passwordTextField.becomeFirstResponder()
        default:
            break
        }
    }
}

extension SignupTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            telTextField.becomeFirstResponder()
        }
        
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
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let tel = self.telTextField.text else { return }
//        guard let name = self.nameTextField.text else { return }
//        guard let code = self.codeTextField.text else { return }
//        guard let password = self.passwordTextField.text else { return }
//        
//        if !tel.isEmpty && !name.isEmpty && !code.isEmpty && !password.isEmpty {
//            
//            signupButton.isEnabled = false
//            signupButton.backgroundColor = UIColor.gray
//        }
//    }
}


