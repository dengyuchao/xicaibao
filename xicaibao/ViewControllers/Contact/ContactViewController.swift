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
    var friendList: [User] = [User]()
    
    var dataArray: NSMutableArray = NSMutableArray()
    var users: [User] = [User]()
    
    // 最终排序的数组
    var resultFriends: [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupview()
        
        self.initDataSource()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupview() {
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 52
        
        // 设置右侧索引
        // 字母颜色
        tableView.sectionIndexColor = UIColor.darkGray
        // 背景颜色
        tableView.sectionIndexBackgroundColor = UIColor.clear
    }
    
    
    func getContactList() {
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        // API请求获取数据
        ApiManager().getContacts(forUser: uuid, token: token, successBlock: { (friends) in
            
            self.friendList = friends
            
        }) { (error) in
            print("[ContactViewController getContactList] \(error) ")
        }
    }
    
    func initDataSource() {
        
        // API获取数据
        //        self.getContactList()
        
//        var users: [User] = [User]()
        let u1 = User(uuid: "", authToken: "", userName: "张三", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u2 = User(uuid: "", authToken: "", userName: "李晓霞", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u3 = User(uuid: "", authToken: "", userName: "陈小", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u4 = User(uuid: "", authToken: "", userName: "王二", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u5 = User(uuid: "", authToken: "", userName: "aaa", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u6 = User(uuid: "", authToken: "", userName: "江大", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u7 = User(uuid: "", authToken: "", userName: "江林", userTel: "", imageUrl: "", nickName: nil, card: nil)
        let u8 = User(uuid: "", authToken: "", userName: "江小", userTel: "", imageUrl: "", nickName: nil, card: nil)
        users.append(u1)
        users.append(u2)
        users.append(u3)
        users.append(u4)
        users.append(u5)
        users.append(u6)
        users.append(u7)
        users.append(u8)
        
        // MARK: 获取名字数组
        var names: [String] = [String]()
//        guard let friends = users else { return }
        
        for fr in self.users {
            var name: String?
            
            if (fr.nickName != nil) {
                name = fr.nickName
            } else {
                name = fr.userName
            }
           
            names.append(name!)
        }
        
        
        
        let nsArray = names as NSArray
        // name sort
        if let indexArray = nsArray.withPinYinFirstLetterFormat() {
            self.dataArray = NSMutableArray(array: indexArray)
//            self.tableView.reloadData()
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "friendDetailVC" {
//            
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                
//                let friend = self.resultFriends[indexPath.row]
//                
//                let friendDetailVC = segue.destination as? FriendDetailTableViewController
//                friendDetailVC?.friend = friend
//                friendDetailVC?.indexPath = indexPath
//                friendDetailVC?.delegate = self
//            }
//        }
//    }
    
    }

extension ContactViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.dataArray.count > 0 {
            return self.dataArray.count + 1
        } else {
            return 1
        }
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows: Int = 0
        if section == 0 {
            rows = 3
        } else {
            let dict: NSDictionary = self.dataArray[section - 1] as! NSDictionary
            let contentArray: NSMutableArray = dict["content"] as! NSMutableArray
            rows = contentArray.count
        }
       return rows
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        if indexPath.section == 0 {
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
            
        } else {

            let placeholderImage = UIImage(named: "tongxunlu_touxiang")
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.layer.cornerRadius = (cell.imageView?.layer.bounds.height)! / 2
            cell.imageView?.image = placeholderImage
            
            let dict: NSDictionary = self.dataArray[indexPath.section - 1] as! NSDictionary
            let contentArray: NSMutableArray = dict["content"] as! NSMutableArray
            
            let name = contentArray[indexPath.row] as? String
            cell.textLabel?.text = name
        
            // 遍历数组，获取对应的头像
            for fr in self.users {
                if fr.nickName == name || fr.userName == name {
//                    if let imageUrl = fr.imageUrl {
//                        cell.imageView?.af_setImage(withURL: URL(string: imageUrl)!)
//                    } else {
//                        cell.imageView?.image = placeholderImage
//                    }
//                    

                }
            }
            
        }
    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        } else {
            
            self.performSegue(withIdentifier: "friendDetailVC", sender: "")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        } else {
            return 21.0
        }
    }
    
    
    // 添加TableView头视图标题
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        } else {
            
            let dict: NSDictionary = self.dataArray[section - 1] as! NSDictionary
            let title = dict["firstLetter"] as! String
            return title
        }
    }
    
    // 添加索引栏标题数组
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if self.dataArray.count > 0 {
            let resultArray = NSMutableArray(array: [UITableViewIndexSearch])
            for data in self.dataArray {
                
                let dict: NSDictionary = data as! NSDictionary
                let title: String = dict["firstLetter"] as! String
                resultArray.add(title)
            }
            
            return resultArray as? [String]
        } else {
            return nil
        }
    }
    
    // 点击索引栏标题时执行
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if title == UITableViewIndexSearch {
            // tabview移至顶部
            tableView.setContentOffset(CGPoint.zero, animated: false)
            
            return NSNotFound;
        } else {
            // -1 添加了搜索标识
            return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index - 1)
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
