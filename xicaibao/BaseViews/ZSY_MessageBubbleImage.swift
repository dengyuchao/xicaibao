//
//  ZSYMessageBubbleImage.swift
//  ChatMessageDemo
//
//  Created by dengyuchao on 16/3/21.
//  Copyright © 2016年 dengyuchao. All rights reserved.
//

import UIKit

class ZSY_MessageBubbleImage: UIImage {
    
    var messageBubbleImage: UIImage?
    var messageBubbleHighlightedImage: UIImage?
    
    convenience init(messageBubbleImage: UIImage, messageBubbleHighlightedImage: UIImage) {
        self.init()
        self.messageBubbleImage = messageBubbleImage
        self.messageBubbleHighlightedImage = messageBubbleHighlightedImage
    }
}
