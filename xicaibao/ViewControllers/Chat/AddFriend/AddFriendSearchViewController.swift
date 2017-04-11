//
//  AddFriendSearchTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/7.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class AddFriendSearchViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friend: User?
    var telString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加好友"
        
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
        
        tableview.rowHeight = 52.0
        
        self.telString = searchBar.text ?? ""
    }
    
    
    func getData(searchText: String) {
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().searchNewFriend(tel: searchText, forUser: uuid, token: token, successBlock: { (user) in
            
            self.friend = user
            // reload data
            self.tableview.reloadData()
            
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
    }
    
}

extension AddFriendSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (self.friend != nil) {
//            return 1
//        } else {
//            return 0
//        }
        
        return 1
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
