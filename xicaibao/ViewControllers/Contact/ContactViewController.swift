//
//  ContactViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var friendList: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 52
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func getContactList() {
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getContacts(forUser: uuid, token: token, successBlock: { (friends) in
            
            self.friendList = friends
            
        }) { (error) in
            print("[ContactViewController getContactList] \(error) ")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendDetailVC" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let friend = self.friendList?[indexPath.row]
                
                let friendDetailVC = segue.destination as? FriendDetailTableViewController
                friendDetailVC?.friend = friend
                friendDetailVC?.indexPath = indexPath
                friendDetailVC?.delegate = self
            }
        }
    }
}

extension ContactViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
            
        case 1:
            if self.friendList != nil {
                return (self.friendList?.count)!
            } else {
                return 2
            }
            
            
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.imageView?.image = UIImage(named: "new_friend")
                cell.textLabel?.text = "新朋友"
            case 1:
                cell.imageView?.image = UIImage(named: "qunzu")
                cell.textLabel?.text = "群组"
            case 2:
                cell.imageView?.image = UIImage(named: "gongzhonghao")
                cell.textLabel?.text = "公众号"
            default:
                break
            }
            
        case 1:
            if let friends = self.friendList {
                
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
            
            
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        } else {
            return 21.0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        } else {
            return "联系人"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "friendDetailVC", sender: "")
        }
    }
}

extension ContactViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "contactSearchVC", sender: "nil")
        
        return false
    }
}

extension ContactViewController: FriendDetailTableViewControllerDelegate {
    func didNickNameSave(nickName: String, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.text = nickName
        tableView.reloadData()
    }
    
    func didPostBolck(indexPath: IndexPath) {
        // 加入黑名单之后删除对应的cell
        tableView.deleteRows(at: [indexPath], with: .none)
        tableView.reloadData()
    }
}
