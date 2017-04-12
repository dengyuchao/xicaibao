//
//  ColorValue.swift
//  xicaibao
//
//  Created by impressly on 2017/3/22.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
extension UIColor {
    // #0195ff
    static func kThemeColor() -> UIColor {
        
        return UIColor(red: 1.0 / 255.0, green: 149.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    static func KTButtonColor() -> UIColor {
        return UIColor(red: 110.0 / 255.0, green: 178.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
    }
    
    //  #696969
    static func kTitleColor() -> UIColor {
        
        return UIColor(red: 105.0 / 255.0, green: 105.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    
    static func kMessageBubbleLightGrayColor() -> UIColor {
        
        return UIColor(hue: 240.0 / 360.0, saturation: 0.02, brightness: 0.92, alpha: 1.0)
    }
    
    func zsy_colorByDarkeningColorWithValue(_ value: CGFloat) -> UIColor {
        let totalComponents = self.cgColor.numberOfComponents
        let isCreyscale = totalComponents == 2 ? true : false
        
        let oldComponents = self.cgColor.components
        var newComponents: [CGFloat] = []
        for _ in 0...3 {
            newComponents.append(0.0)
        }
        
        if isCreyscale {
            newComponents[0] = (oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value
            newComponents[1] = (oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value
            newComponents[2] = (oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value
            newComponents[3] = (oldComponents?[1])!
        } else {
            newComponents[0] = (oldComponents?[0])! - value < 0.0 ? 0.0 : (oldComponents?[0])! - value
            newComponents[1] = (oldComponents?[1])! - value < 0.0 ? 0.0 : (oldComponents?[1])! - value
            newComponents[2] = (oldComponents?[2])! - value < 0.0 ? 0.0 : (oldComponents?[2])! - value
            newComponents[3] = (oldComponents?[3])!
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColor(colorSpace: colorSpace, components: newComponents)
        
        if let newColor = newColor {
            return UIColor(cgColor: newColor)
        } else {
            return self
        }
    }
}

