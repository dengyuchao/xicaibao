//
//  ChatRoomTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/5.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: ChatMessagesSendButton!
    @IBOutlet weak var textView: ChatMessagesTextView!
    
    @IBOutlet weak var chatMessageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
