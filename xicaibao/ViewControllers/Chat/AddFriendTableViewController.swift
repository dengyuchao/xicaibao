//
//  AddFriendTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/5.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class AddFriendTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "添加好友"
    }

}

extension AddFriendTableViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "searchFriend", sender: "nil")
        
        return false
    }
}
