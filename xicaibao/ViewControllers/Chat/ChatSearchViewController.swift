//
//  ChatSearchViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/1.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ChatSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupview()
    }
    
    private func setupview() {
        searchBar.becomeFirstResponder()
        
        // set searchbar cancel button
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.setTitle("取消", for: .normal)
        uiButton.setTitleColor(UIColor.white, for: .normal)
}


}

extension ChatSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.dismiss(animated: false, completion: nil)
    }
}
