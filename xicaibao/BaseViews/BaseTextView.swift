//
//  BaseTextView.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //  AdjustUI
        tintColor = UIColor.kThemeColor()
        textColor = UIColor.kTitleColor()
        font = UIFont.systemFont(ofSize: 16.0)
        
        //  AdjustRespond
        becomeFirstResponder()
    }
    
    func setPlaceHoderText(_ placeHoder: String) {
        var range = NSRange()
        range.location = 0
        setMarkedText(placeHoder, selectedRange: range)
        unmarkText()
    }
}
