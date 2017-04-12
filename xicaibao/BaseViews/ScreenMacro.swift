//
//  LayoutMacro.swift
//  Youli
//
//  Created by dengyuchao on 15/10/28.
//  Copyright © 2015年 dengyuchao. All rights reserved.
//

import UIKit

//  获取设备宽高
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

//  获取设备尺寸
func kScreenSize() -> Float {
    if kScreenWidth == 320 && kScreenHeight == 480 {
        return 3.5
    } else if kScreenWidth == 320 && kScreenHeight == 568 {
        return 4.0
    } else if kScreenWidth == 375 && kScreenHeight == 667 {
        return 4.7
    } else if kScreenWidth == 414 && kScreenHeight == 736 {
        return 5.5
    } else {
        return 4.7
    }
}
