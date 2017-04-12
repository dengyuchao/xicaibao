//
//  ChatMessagesSendButton.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class ChatMessagesSendButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        isEnabled = false
        titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        tintColor = UIColor.kThemeColor()
    }
}
