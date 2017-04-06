//
//  CreateCardTableViewController.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/16.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import UIKit

class CreateCardTableViewController: UITableViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var comTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var TelTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // var user: User???
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupView()

    }
    
        private func setupView() {
            
            title = "创建名片"
            tableView.tableFooterView = UIView()
            
            photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2.0
            
            self.saveButton.isEnabled = false
            
            self.nameTextField.delegate = self
            self.emailTextField.delegate = self
            self.comTextField.delegate = self
            self.TelTextField.delegate = self
            self.jobTextField.delegate = self
            self.addressTextView.delegate = self
        }
    
    
    // MARK: savaButton state
    public func saveButtonState() {
        self.saveButton.isEnabled = self.formIsValid()
    }
    
    
    // MARK: 判断输入是否为空
    private func formIsValid() -> Bool {
        if self.nameTextField.anyText() &&
            self.TelTextField.anyText() &&
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
    
    
    //电话号码输入字数限制
    func telDidChanged(sender:UITextField) {
        var textStr = sender.text
        var num = textStr?.characters.count
        if num! > 11 {
            textStr = (textStr! as NSString).substring(to: 11)
            num = 11
        }
        sender.text = textStr
        
    }
    
    
    
    @IBAction func nameDidEndAction(_ sender: UITextField) {
        nameDidChanged(sender: sender)
    }
    
    
    @IBAction func telDidEndAction(_ sender: UITextField) {
        telDidChanged(sender: sender)
    }
    
    
    
    
    // MARK: saveButton action
    @IBAction func saveAction(_ sender: Any) {
        
        guard let name: String = self.nameTextField.text else { return }
        guard let job: String = self.jobTextField.text else { return }
        guard let tel: String = self.TelTextField.text else { return }
        guard let email: String = self.emailTextField.text else { return }
        guard let com: String = self.comTextField.text else { return }
        guard let address: String = self.addressTextView.text else { return }
        
        let card = Card(key: "", name: name, tel: tel, job: job, address: address, email: email, com: com)
        
        //  API请求  post  保存至服务器
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        ApiManager().postCard(card: card, forUser: uuid, token: token, successBlock: { (card) in
            
            // 上传成功
            self.navigationController!.popViewController(animated: true)
            
        }) { (error) in
            
            print("[CreateCardTableViewController saveAction] 上传名片失败 \(error.localizedDescription)")
        }
    }
}


extension CreateCardTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.nameTextField.becomeFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.TelTextField.resignFirstResponder()
            
            break
        
        case 1:
            self.jobTextField.becomeFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.TelTextField.resignFirstResponder()
            
            break
            
        case 2:
            self.TelTextField.becomeFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
  
            break
        
        case 3:
            self.emailTextField.becomeFirstResponder()
            self.TelTextField.resignFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
            self.comTextField.resignFirstResponder()
            
            break
        
        case 4:
            self.comTextField.becomeFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.TelTextField.resignFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.addressTextView.resignFirstResponder()
      
            break
            
        case 5:
            self.addressTextView.becomeFirstResponder()
            self.comTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.TelTextField.resignFirstResponder()
            self.jobTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            
            break
            
        default:
            break
        }
    }
}

extension CreateCardTableViewController: UITextFieldDelegate {
    
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
            TelTextField.becomeFirstResponder()
        }
        
        if textField == TelTextField {
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

extension CreateCardTableViewController: UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addressTextView.resignFirstResponder()
    }
    func textViewDidChange(_ textView: UITextView) {
        saveButtonState()
    }
}
