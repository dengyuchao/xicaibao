//
//  DateHelper.swift
//  xicaibao
//
//  Created by impressly on 2017/4/12.
//  Copyright © 2017年 impressly. All rights reserved.
//

import Foundation

open class DateHelper {
    
    class func todayDate() -> Date {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        
        return calendar.date(from: components)!
    }
    
    class func cstFromUtc(_ dateString: String!) -> String {
        
        if (dateString == "" || dateString == nil) {
            return ""
        }
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = utcDateFormatter.date(from: dateString)
        
        if (date == nil) {
            return ""
        }
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cstDateFormatter.timeZone = TimeZone.autoupdatingCurrent // China Standard Time
        let cstStr = cstDateFormatter.string(from: date!)
        
        return cstStr
        
    }
    
    class func cstDate(_ dateString: String!) -> Date {
        // assume dateString is cst format
        
        let cstDateFormatter = DateFormatter()
        cstDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cstDateFormatter.timeZone = TimeZone.autoupdatingCurrent // China Standard Time
        
        return cstDateFormatter.date(from: dateString)!
    }
    
    class func shortDate(_ date: Date) -> String {
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "MMM-dd"
        
        return shortDateFormatter.string(from: date)
    }
    
    class func shortDateTime(_ date: Date) -> String {
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "MMM-dd HH:mm"
        
        return shortDateFormatter.string(from: date)
    }
    
    class func dateStringForEvent(_ date:Date) ->String {
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "yyyy/MM/dd"
        
        return shortDateFormatter.string(from: date)
    }
    
    class func dateForEventString(_ dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateStr)
    }
    
    class func stringForEventDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(_ dateToCompare : Date) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
}



// MARK: public method for converting date to string.
extension Date {
    func dateStr() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let dateStr: String = formatter.string(from: self)
        return dateStr
    }
}

extension String {
    func toDate() -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        if let date: Date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}


// MARK: - ChatMessages Data Model

extension Date {
    // ChatMessage 显示日期格式
    func toMessageDate() -> String {
        guard let isYesterDay = isYesterDay() else { return "" }
        let formatter = DateFormatter()
        if isThisYear() {   // 今年
            if isYesterDay { // 昨天
                formatter.dateFormat = "昨天 HH:mm"
            }
            else if isToday() { // 今天
                let cmps = detailFormDate()
                if cmps.hour! >= 1 { // 1小时 - 1天
                    formatter.dateFormat = "今天 HH:mm"
                } else if cmps.minute! >= 1 { // 1分钟 - 1小时 之间
                    return "\(cmps.minute!)分钟前"
                } else {    // 1分钟内
                    return "刚刚"
                }
            }
            else { // 今年 昨天以前
                formatter.dateFormat = "MM月dd日 E HH:mm"
            }
        }
            // 去年以前
        else {    // 年-月-日
            formatter.dateFormat = "yyyy年MM月dd"
        }
        return formatter.string(from: self)
    }
    
    // 日期差值
    fileprivate func detailFormDate() -> DateComponents {
        let calender = Calendar.current
        return (calender as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: self, to: Date(), options: NSCalendar.Options())
    }
    
    // 是否今年
    fileprivate func isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowYear = (calendar as NSCalendar).component(.year, from: Date())
        let selfYear = (calendar as NSCalendar).component(.year, from: self)
        return nowYear == selfYear
    }
    
    // 是否今天
    fileprivate func isToday() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let nowString = formatter.string(from: Date())
        let selfString = formatter.string(from: self)
        
        return nowString == selfString
    }
    
    // 是否昨天
    fileprivate func isYesterDay() -> Bool? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let nowDate = formatter.date(from: formatter.string(from: Date())) else { return nil }
        guard let selfDate = formatter.date(from: formatter.string(from: self)) else { return nil }
        let calendar = Calendar.current
        let cmps = (calendar as NSCalendar).components([.year, .month, .day], from: selfDate, to: nowDate, options: NSCalendar.Options())
        
        return cmps.year == 0 && cmps.month == 0 && cmps.day == 1
    }
}

//  OrderDate
extension Date {
    func toOrderDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
