//
//  EditCardTableViewController.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/16.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import UIKit

class EditCardTableViewController: UITableViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var comTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupOldView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //每次进来服务器获取最新的card
        // TODO: API请求
        
    }
    
    private func setupView() {
        
        title = "编辑名片"
        tableView.tableFooterView = UIView()
        
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2.0
        
        // delegate
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.comTextField.delegate = self
        self.telTextField.delegate = self
        self.jobTextField.delegate = self
        self.addressTextView.delegate = self
    }
    
    // MARK:显示名片上已存信息
    private func setupOldView() {
        
        guard let card = self.card else { return }
        self.nameTextField.text = card.name
        self.jobTextField.text = card.job
        self.telTextField.text = card.tel
        self.emailTextField.text = card.email
        self.comTextField.text = card.com
        self.addressTextView.text = card.address
    }
    
    
    // MARK: savaButton state
    public func saveButtonState() {
        self.saveButton.isEnabled = self.formIsValid()
    }
    
    
    // MARK: 判断输入是否为空
    private func formIsValid() -> Bool {
        if self.nameTextField.anyText() &&
            self.telTextField.anyText() &&
            self.jobTextField.anyText() &&
            self.comTextField.anyText() &&
            self.emailTextField.anyText() &&
            self.addressTextView.anyText(){
            
            return true
            
        } else {
            return false
        }
    }
    
    //MARK: 名字输入字数限制
    func nameDidChanged(sender: UITextField) {
        
        var textStr = sender.text
        var num = textStr?.characters.count
        if num! > 20 {
            textStr = (textStr! as NSString).substring(to: 20)
            num = 20
        }
        sender.text = textStr
    }
    
    
    //电话号码输入限制
    func telDidChanged(sender:UITextField) {
        var textStr = sender.text
        var num = textStr?.characters.count
        if num! > 11 {
            textStr = (textStr! as NSString).substring(to: 11)
            num = 11
        }
        sender.text = textStr
        
    }
  
    
    @IBAction func nameDidEnd(_ sender: UITextField) {
        nameDidChanged(sender: sender)
    }
    
    
    @IBAction func telDidEnd(_ sender: UITextField) {
        telDidChanged(sender: sender)
    }
    
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if let name = self.nameTextField.text {
            self.card?.name = name
        }
        
        if let job = self.jobTextField.text {
            self.card?.job = job
        }
        
        if let tel = self.telTextField.text {
            self.card?.tel = tel
        }
        
        if let email = self.emailTextField.text {
            self.card?.email = email
        }
        
        if let com = self.comTextField.text {
            self.card?.com = com
        }
        
        if let address = self.addressTextView.text {
            self.card?.address = address
        }
        
        // API patch 更新
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().patchCard(card: self.card!, forUser: uuid, token: token, successBlock: { (card) in
            // 更新成功
            self.navigationController!.popViewController(animated: true)
        }) { (error) in
            // 更新失败
            print("[EditCardTableViewController saveAction] 名片更新失败:\(error.localizedDescription)")
        }
    }
}

extension EditCardTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.nameTextField.becomeFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.telTextField.resignFirstResponder()
            
            break
            
        case 1:
            self.jobTextField.becomeFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.telTextField.resignFirstResponder()
            
            break
            
        case 2:
            self.telTextField.becomeFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            
            break
            
        case 3:
            self.emailTextField.becomeFirstResponder()
            self.telTextField.resignFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            
            break
            
        case 4:
            self.comTextField.becomeFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.telTextField.resignFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            
            break
            
        case 5:
            self.addressTextView.becomeFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.telTextField.resignFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            
            break
            
        default:
            break
        }
    }
}

extension EditCardTableViewController: UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        saveButtonState()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        saveButton.isEnabled = false
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            jobTextField.becomeFirstResponder()
        }
        
        if textField == jobTextField {
            telTextField.becomeFirstResponder()
        }
        
        if textField == telTextField {
            emailTextField.becomeFirstResponder()
        }
        
        if textField == emailTextField {
            comTextField.becomeFirstResponder()
        }
        
        if textField == comTextField {
            addressTextView.becomeFirstResponder()
        }
        
        return true
    }
}

extension EditCardTableViewController: UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      
        addressTextView.resignFirstResponder()
    }
    func textViewDidChange(_ textView: UITextView) {
        saveButtonState()
    }
}

