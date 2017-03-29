//
//  FormatHelper.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/17.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    func anyText() -> Bool {
        if let text = self.text {
            if text.characters.count > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

extension UITextView {
    func anyText() -> Bool {
        if let text = self.text {
            if text.characters.count > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

extension UILabel {
    func anyText() -> Bool {
        if let text = self.text {
            if text.characters.count > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
