//
//  BankCardListTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class BankCardListTableViewController: UITableViewController {
    
    var bankNameList = [String]()
    var bankIconList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "银行卡列表"
        tableView.tableFooterView = UIView()
        
        self.getData()
    }
    
    func getData() {
        // bankCardList data
        let bankData = BankCardData.getBankCardData()
        
        // 取出所有名字
        for name in bankData.keys {
            bankNameList.append(name)
        }
        
        // 取出所有icon
        for icon in bankData.values {
            bankIconList.append(icon)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return bankNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankCardListCell", for: indexPath)
        
        cell.textLabel?.text = bankNameList[indexPath.row]
        
        cell.imageView?.image = UIImage(named: bankIconList[indexPath.row])
        
        return cell
    }
}
