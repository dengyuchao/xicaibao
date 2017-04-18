//
//  BaseTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation
import UIKit
import DZNEmptyDataSet


struct EmptyViewModel {
    var alert: String?  // 提示标题
    var prompt: String? // 提示内容
}

class BaseTableViewController: UITableViewController {
    
//    fileprivate var isHiddenStateBar = false
    
    var emptyViewModel: EmptyViewModel? {
        willSet {
            configEmptyView()
        }
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.tintColor = UIColor.kThemeColor()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        guard let selectedRowIndexPath = self.tableView.indexPathForSelectedRow else { return }
//        self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
    fileprivate func configEmptyView() {

        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
}

extension BaseTableViewController: DZNEmptyDataSetSource {
    
    // 返回标题文字
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let model = emptyViewModel else { return NSAttributedString() }
        if let alert = model.alert {
            
            let stringAttributed = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0), NSForegroundColorAttributeName : UIColor.lightGray]
            let string = NSAttributedString(string: alert, attributes: stringAttributed)
            return string
        } else {
            return NSAttributedString()
        }
    }
    
    // 返回内容详细描述
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let model = emptyViewModel else { return NSAttributedString() }
        if let prompt = model.prompt {
            let stringAttributed = [NSFontAttributeName : UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName : UIColor.lightGray]
            let string = NSAttributedString(string: prompt, attributes: stringAttributed)
            return string
        } else {
            return NSAttributedString()
        }
    }

    // 空白的图片显示
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "blankIcon")
    }
    
    // 空白界面的背景颜色
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
}

extension BaseTableViewController: DZNEmptyDataSetDelegate {
    
    // 数据源为空时是否渲染和显示
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        
        return true
    }
}


