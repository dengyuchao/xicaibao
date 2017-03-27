//
//  LoginTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/23.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var signButton: UIBarButtonItem!
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    
    var onSuccess: (() -> Void)?
    var onCancel: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 显示底部按钮
        self.navigationController?.isToolbarHidden = false
    }
    private func setupView() {
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        loginActivity.isHidden = true
        
        telTextField.delegate = self
        passwordTextField.delegate = self
        iconImage.layer.cornerRadius = iconImage.layer.bounds.width / 2
        loginButton.layer.cornerRadius = loginButton.layer.bounds.height / 8
        resetButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.kThemeColor()], for: .normal)
        signButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.kThemeColor()], for: .normal)
    }
    
    private func login(tel:String, password: String) {
        
        self.logging()
        
        LoginManager.defaultManager.login(tel, password: password, onSuccess: {user in
            // 登录成功
            self.onSuccess?()
        
        }) { (error) in
            self.continueLogin()
            
            // TODO:根据服务器返回的错误类型，提示错误信息
            print("[LoginTableViewController login] \(error.localizedDescription)")
            
            self.onCancel?()
        }
    }
    
    private func logging() {
        loginButton.isHidden = true
        loginActivity.isHidden = false
        loginActivity.startAnimating()
    }
    
    private func continueLogin() {
        loginButton.isHidden = false
        loginActivity.stopAnimating()
    }
    
    
    // action
    @IBAction func loginAction(_ sender: UIButton) {
        guard let tel = self.telTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        self.login(tel: tel, password: password)
    }
}

extension LoginTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            telTextField.becomeFirstResponder()
        }
        if indexPath.row == 1 {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    // segue 传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "signupVC" {
            if let signupVC = segue.destination as? SignupTableViewController  {
                signupVC.onSuccess = {(tel: String, password: String) -> Void in
                    self.telTextField.text = tel
                    self.passwordTextField.text = password
                }
            }
        }
        
        if segue.identifier == "resetPasswordVC" {
            if let resetVC = segue.destination as? ResetPasswordTableViewController {
                resetVC.onSuccess = {(tel: String, password: String) -> Void in
                    self.telTextField.text = tel
                    self.passwordTextField.text = password
                }
            }
        }
    }
}

extension LoginTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == telTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
