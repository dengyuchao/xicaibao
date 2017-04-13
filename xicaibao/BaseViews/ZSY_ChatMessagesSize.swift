//
//  ZSY_ChatMessagesSize.swift
//  Xinkongjian
//
//  Created by dengyuchao on 16/3/31.
//  Copyright © 2016年 dengyuchao. All rights reserved.
//

import UIKit

class ZSY_ChatMessagesSize: NSObject {
    static let avatarWidth: CGFloat = 32.0
    static let cellBoderWidth: CGFloat = 8.0
    static let contentViewLeftLayoutConstraint: CGFloat = 2.0
    static let messageLabelBoderLayoutConstraint: CGFloat = 16.0
    static let cellTopLabelHeight: CGFloat = 38.0
    static let bottomViewHeight: CGFloat = 18.0
}

struct Font {
    //  FontSize
    static let kTitleFontSize: CGFloat = 16.0
}

extension String {
    
    func textSizeWithFont(_ font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        
        var textSize:CGSize!
        if size.equalTo(CGSize(width: 0, height: 0)) {
            
            textSize = self.size(attributes: [NSFontAttributeName : font])
            
        } else {
            
            let originSize = self.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
            
            let fontLeadingSize = self.boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: [NSFontAttributeName : font], context: nil).size
            
            let unionSize = CGSize(width: originSize.width + fontLeadingSize.width, height: originSize.height + fontLeadingSize.height)
            
            textSize = unionSize
        }
        
        return textSize
    }
}

