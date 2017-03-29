//
//  EditNameTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/28.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

protocol EditNameTableViewControllerDelegate: NSObjectProtocol {
    
    func editNameSave(name: String)
}

class EditNameTableViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    
    var user: User?
    
    weak var delegate: EditNameTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        doneButton.isEnabled = false
        
        nameTextField.delegate = self
        guard let user = self.user else { return }
        nameTextField.text = user.userName
        
    }
    
    public func buttonState() {
        doneButton.isEnabled = (nameTextField.text?.characters.count)! > 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    // actions
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text else { return }
        
        // delegate
        self.delegate?.editNameSave(name: name)
        
        self.navigationController!.popViewController(animated: true)
        
        guard let user = self.user else { return }
        user.userName = name
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        // API请求 更新用户信息
        ApiManager().patchProfile(user, uuid: uuid, token: token, successBlock: { (user) in
            print("[EditNameTableViewController patchProfile] success")
        }) { (error) in
            print("[EditNameTableViewController patchProfile] \(error.localizedDescription)")
        }
    }
    
}

extension EditNameTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        buttonState()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nameTextField.resignFirstResponder()
        }
        return true
    }
    
}
