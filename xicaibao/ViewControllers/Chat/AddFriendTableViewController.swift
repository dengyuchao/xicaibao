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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addFriendSearch" {
            
            if let searchVC = segue.destination as? AddFriendSearchViewController {
                
                // 搜索好友
            }
        }
    }

}

extension AddFriendTableViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "addFriendSearch", sender: "nil")
        
        return false
    }
}
