//
//  Date+Extension.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import Foundation

extension Date: NamespaceWrappable {}

extension NamespaceWrapper where T == Date {
    
    /// date转string
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: warppedValue)
    }
    
    /// 时间描述 describe
    func timeDisplay() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .weekday, .minute, .second], from: warppedValue, to: date)
        if let year = components.year, year >= 1 {
            return "\(year)年前"
        }
        if let month = components.month, month >= 1 {
            return "\(month)月前"
        }
        if let day = components.day, day >= 1 {
            return "\(day)天前"
        }
        if let hour = components.hour, hour >= 1 {
            return "\(hour)小时前"
        }
        if let minute = components.minute, minute >= 1 {
            return "\(minute)分钟前"
        }
        if let second = components.second, second >= 1 {
            return "\(second)秒钟前"
        }
        
        return "刚刚"
        
    }
    
    /**
     判断两个日期是不是同一天
     1、字符串判断
     2、年月日比较
     3、使用Calendar的isDate方法进行判断
     */
    
    /*
    func isSameDay(compareDate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if formatter.string(from: warppedValue) == formatter.string(from: compareDate) {
            print("同一天")
            return true
        }
        print("不是同一天")
        return false
    }
     */
    
    /*
    func isSameDay(compareDate: Date) -> Bool {
        let calender = Calendar.current
        let start = calender.dateComponents([.year, .month, .day], from: warppedValue)
        let end = calender.dateComponents([.year, .month, .day], from: compareDate)
        if start.year == end.year && start.month == end.month && start.day == end.day {
            print("同一天")
            return true
        }
        print("不是同一天")
        return false
    }
     */
    
    func isSameDay(compareDate: Date) -> Bool {
        if Calendar.current.isDate(warppedValue, inSameDayAs: compareDate) {
            print("同一天")
            return true
        }
        print("不是同一天")
        return false
    }
 
}
