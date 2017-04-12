//
//  ChatMessagesTextView.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ChatMessagesTextView: BaseTextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        resignFirstResponder()
    }
}

