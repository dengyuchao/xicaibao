//
//  SystemPathHelper.swift
//  Xinkongjian
//
//  Created by dengyuchao on 16/5/11.
//  Copyright © 2016年 ONTHETALL. All rights reserved.
//

import Foundation

struct SystemPathHelper {
    
    fileprivate static let BUNDLE_ID = (Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String) ?? ""
    
    static let kSystemSettingsPath = URL(string: "prefs:root=\(BUNDLE_ID)&&path=ManagedConfigurationList")!
}
