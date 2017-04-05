//
//  InitiateChatTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/5.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class InitiateChatTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension InitiateChatTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "initCell", for: indexPath)
        
        return cell
    }
}

extension InitiateChatTableViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "initSearchVC", sender: "nil")
        
        return false
    }
}
