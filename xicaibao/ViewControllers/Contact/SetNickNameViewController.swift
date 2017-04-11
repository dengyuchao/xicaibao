//
//  SetNickNameViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/10.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

protocol SetNickNameTableViewControllerDelegate: NSObjectProtocol {
    
    func editNickNameSave(nickName: String)
}
class SetNickNameTableViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    
    var nickName: String?
    
    weak var delegate: SetNickNameTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        doneButton.isEnabled = false
        nickNameTextField.delegate = self
        
        guard let nickName = self.nickName else { return }
        nickNameTextField.text = nickName
    }

    func buttonState() {
        
        doneButton.isEnabled = (nickNameTextField.text?.characters.count)! > 0
    }
    
    @IBAction func doneBtAction(_ sender: UIBarButtonItem) {
        
        guard let nickName = self.nickNameTextField.text else { return }
        
        // delegate
        self.delegate?.editNickNameSave(nickName: nickName)
        self.navigationController?.popViewController(animated: true)
}
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 21.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            nickNameTextField.becomeFirstResponder()
        }
    }
}

extension SetNickNameTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        buttonState()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nickNameTextField {
            nickNameTextField.resignFirstResponder()
        }
        return true
    }

}


