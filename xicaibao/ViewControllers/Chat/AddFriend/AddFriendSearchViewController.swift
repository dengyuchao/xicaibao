//
//  AddFriendSearchTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/7.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class AddFriendSearchViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var telString: String?
    var friendList: [User] = [User]()
    
    var friend: User?
    
    var oldFriend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加好友"
        
        self.setupview()
        self.getContacts()
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
        
        tableview.rowHeight = 52.0
        
        self.telString = searchBar.text ?? ""
    }
    
    
    func getContacts() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getContacts(forUser: uuid, token: token, successBlock: { (friends) in
            self.friendList = friends
            
        }) { (error) in
            print("[AddFriendSearchViewController getContacts]\(error.localizedDescription)")
        }
    }
    
    func getData(searchText: String) {
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().searchNewFriend(tel: searchText, forUser: uuid, token: token, successBlock: { (user) in
            
            self.friend = user
            // reload data
            self.tableview.reloadData()
            
            // MARK: 判断是否是已经添加的好友
            for fr in self.friendList {
                if self.friend?.uuid == fr.uuid {
                    self.oldFriend = self.friend
                }
            }
            
        }) { (error) in
            
            print("[AddFriendSearchViewController searchNewFriend failed] \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            if segue.identifier == "addFriendDetailVC" {
                if let vc = segue.destination as? AddFriendDetailViewController {
                    
                    if self.friend != nil {
                        vc.friend = self.friend
                    }
                }
            }
       
            if segue.identifier == "friendDesc" {
                if let vc = segue.destination as? FriendDetailTableViewController {
                    vc.friend = self.oldFriend
            }
        }
    }
}

extension AddFriendSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.friend != nil  || self.oldFriend != nil {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let placeholderImage = UIImage(named: "tongxunlu_touxiang")
        
        if (self.friend != nil) {
            if let imageUrl = URL(string: (self.friend?.imageUrl)!) {
                cell.imageView?.af_setImage(withURL: imageUrl)
                cell.imageView?.layer.masksToBounds = true
                cell.imageView?.layer.cornerRadius = (cell.imageView?.layer.bounds.height)! / 2
            } else {
                cell.imageView?.image = placeholderImage
                cell.imageView?.layer.masksToBounds = true
                cell.imageView?.layer.cornerRadius = (cell.imageView?.layer.bounds.height)! / 2
            }
            
            cell.textLabel?.text = self.friend?.userName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.oldFriend == nil {
            
            self.performSegue(withIdentifier: "addFriendDetail", sender: nil)
            
        } else {
            
            self.performSegue(withIdentifier: "friendDesc", sender: nil)
        }
    }
    
}

extension AddFriendSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.telString = searchText
        
        if self.telString?.characters.count == 0 {
            self.friend = nil
        } else {
            
            // API 请求获取数据
            getData(searchText: self.telString!)
        }
    }
    
    func searchBarCancelButtonClicked(_searchBar: UISearchBar)  {
        
        searchBar.resignFirstResponder()
    }
}

