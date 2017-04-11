//
//  ContactSearchViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/11.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ContactSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchString: String?
    var friends: [User]?
    
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUser()
        self.setupview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupview() {
        searchBar.becomeFirstResponder()
        
        // set searchbar cancel button
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.setTitle("取消", for: .normal)
        uiButton.setTitleColor(UIColor.white, for: .normal)
        
        tableView.rowHeight = 52.0
        
        self.searchString = searchBar.text ?? ""
    }
    
    func getUser() {
        
        if self.user == nil {
            guard let uuid = LoginManager.defaultManager.uuid else { return }
            guard let token = LoginManager.defaultManager.authToken else { return }
            
            ApiManager().getProfile(uuid, token: token, successBlock: { (user) in
                self.user = user
            }) { (error) in
                
                print("[ContactSearchViewController getUser] getProfile failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getData(searchText: String) {
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getContacts(forUser: uuid, token: token, successBlock: { (friends) in
            
            self.friends = friends
            self.tableView.reloadData()
            
        }) { (error) in
            print("[ContactSearchViewController getData] getContacts failed:\(error.localizedDescription)")
        }
    }
}

extension ContactSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.friends != nil {
            return self.friends!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactSearchCell", for: indexPath)
        
        if let friends = self.friends {
            
            if let nickName = friends[indexPath.row].nickName {
                cell.textLabel?.text = nickName
            } else {
                cell.textLabel?.text = friends[indexPath.row].userName
            }
            
            
            let placeholderImage = UIImage(named: "tongxunlu_touxiang")
            
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.layer.cornerRadius = (cell.imageView?.layer.bounds.height)! / 2
            
            if let imageUrl = friends[indexPath.row].imageUrl {
                cell.imageView?.af_setImage(withURL: URL(string: imageUrl)!)
            } else {
                cell.imageView?.image = placeholderImage
            }
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.friends == nil {
            return 0
        } else {
            return 21.0
        }
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.friends == nil {
            return nil
        } else {
            return "联系人"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: 进入聊天室
    }
}

extension ContactSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchString = searchText
        
        if self.searchString?.characters.count == 0 {
            self.friends = nil
            
        } else {
            
            // API 请求获取数据
            getData(searchText: self.searchString!)
        }
    }
    
    func searchBarCancelButtonClicked(_searchBar: UISearchBar)  {
        
        searchBar.resignFirstResponder()
    }
}
