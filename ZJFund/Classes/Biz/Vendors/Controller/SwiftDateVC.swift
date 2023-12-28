//
//  SwiftDateVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import UIKit
import SwiftDate

/***
 支持数学运算符进行日期计算（比如 myDate + 2.week + 1.hour)
 支持比较运算符（比如 <、>、==、<=、>=）
 快速获取/修改日期各部分内容（比如获取或修改日期中的月份）
 提供通用格式化输出或自定义的格式化输出
 提供一系列 .toString() 方法
 提供简便的方法获取 yesterday、tomorrow 等
 */

class SwiftDateVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("Test", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension SwiftDateVC {
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.swiftDate6()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension SwiftDateVC {
    
    func testClick() {
        
        /**
         EEEE：表示星期几(Monday)，使用1-3个字母表示周几的缩写
         MMMM：月份的全写(October)，使用1-3个字母表示月份的缩写
         dd：表示日期,使用一个字母表示没有前导0
         YYYY：四个数字的年份
         HH：两个数字表示的小时
         mm：两个数字的分钟
         ss：两个数字的秒
         zzz：三个字母表示的时区
         */
        
        // 获取当前时间
//        let date = Date()
//        print("now: \(date)")
        
        /***
         时间（date）转字符串（string）
         */
        
        /*
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss MMMM EEEE zzz"
        
        let timeString = formatter.string(from: date)
        
        print("====== \(timeString)")
         */
        
        /***
         将时间戳转为日期时间
         */
        
        /*
        /// 获取当前时间戳
        let currentInterval = Date().timeIntervalSince1970 - 24 * 60 * 60
        
        print("currentInterval ===== \(currentInterval)")

        // 时间戳转date
        let timeInterval: TimeInterval = TimeInterval(currentInterval)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        // 格式化
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("====== \(formatter.string(from: date))")
        */
        
        /***
         string转date
         */
        
        /* 存在问题：时间相差八个小时
        let timeString = "2023-12-12 15:30:30"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: timeString)
        print("====== \(date)")
         */
        
        /*
        let timeString = "2023-12-12 15:30:30"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: timeString)
        print("====== \(date)")
         */
        
        /**
         Date到DateComponents
         */
        
        /*
        let currentdate = Date()
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year,.month, .day, .hour,.minute,.second], from: currentdate)

        print("year: \(dateComponents.year), \n month: \(dateComponents.month),\n day: \(dateComponents.day),\n hour: \(dateComponents.hour),\n minute: \(dateComponents.hour),\n second: \(dateComponents.second)")
        */
        
//        let timeString = "2022-11-22 15:30:30"
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        formatter.timeZone = TimeZone(identifier: "UTC")
//        let date = formatter.date(from: timeString)
//        let time = date?.dd.timeDisplay()
//        print("time ====== \(time)")
        
        let currentDate = Date()
        
        let timeString = "2023-12-22 12:30:30"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: timeString)
        
        let same = currentDate.dd.isSameDay(compareDate: date!)
        print(same ? "true" : "false")
        
    }
    
    func swiftDate1() {
        
        /***
         日期解析
         */
        
        // 1.默认格式解析
//        let date = "2018-06-07 12:30:00".toDate()
//        print("date ==== \(date)")
        
        // 2.使用指定格式解析
//        let date1 = "2018-06-07 12:30:00".toDate("yyyy-MM-dd HH:mm")
//        print("date1 ==== \(date1)")
        
        /***
         使用DateInRegion创建Date
         */
        
        // 1.时间字符串创建
        let date2 = DateInRegion("2018-08-08 08:00:00")
        print("date2 ====== \(date2?.date)")
        
        // 2.时间间隔创建
        let date3 = DateInRegion(seconds: 39940)
        let date4 = DateInRegion(milliseconds: 50000)
        print("date3 ====== \(date3.date)")
        print("date4 ====== \(date4.date)")
        
        // 3.指定日期各部分创建
        let date5 = DateInRegion(components: {
            $0.year = 2022
            $0.month = 9
            $0.day = 11
            $0.hour = 12
            $0.minute = 0
        })
        print("date5 ====== \(date5?.date)")
        
        let date6 = DateInRegion(year: 2023, month: 10, day: 17, hour: 22, minute: 17, second: 37)
        print("date6 ====== \(date6.date)")
        
        /***
         也可以指定地区Region创建，相比上面多了一个参数
         */
        
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
        
        // 1.字符串创建
        let date7 = DateInRegion("2012-10-27 10:58:37", region: region)
        print("date7 ===== \(date7?.date)")
        
    }
    
    func swiftDate2() {
        
        /**
         日期的提取
         */
        
        let date = Date()
        print("当前的日期 === \(date)")
        print("年：\(date.year) - 月：\(date.month) - 日：\(date.day)")
        print("时：\(date.hour) - 分：\(date.minute) - 秒：\(date.second)")
        
        /**
         print("本月名称：", date.monthName(.default))
         print("本日名称：", date.weekdayName(.default))
         print("本周第一天：", date.firstDayOfWeek)
         print("本周最后一天：", date.lastDayOfWeek)
         */
        
//        print("本月名称：", date.monthName(.default))
//        print("本日名称：", date.weekdayName(.default))
        
        
        
        // 这一个月有多少天
//        print("这一个月有多少天", date.monthDays)
        
        /**
         var isToday: Bool {
             return calendar.isDateInToday(date)
         }

         var isYesterday: Bool {
             return calendar.isDateInYesterday(date)
         }

         var isTomorrow: Bool {
             return calendar.isDateInTomorrow(date)
         }

         var isInWeekend: Bool {
             return calendar.isDateInWeekend(date)
         }

         var isInPast: Bool {
             return date < Date()
         }

         var isInFuture: Bool {
             return date > Date()
         }
         */
        
        
    }
    
    func swiftDate3() {
        
        /***
         日期格式化输出
         */
        
//        let date = Date()
//        print("时间1：= ", date.toFormat("yyyy-MM-dd HH:mm:ss")) // 不加时区
//        print("时间2：= ", date.convertTo(region: Region(zone: Zones.asiaShanghai)).toFormat("yyyy-MM-dd HH:mm:ss"))
        
        /**
         显示多少..前
         */
//        let date = "2018-09-10 13:30:00".toDate()!
//        let r1 = date.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.chinese)
//        print("r1 ===== \(r1)")
        
        /** TimeInterval
         使用.toClock方法将TimeInterval 输出成"时：分：秒"形式
         */
        
//        let timeInterval = 2.hours.timeInterval + 2.minutes.timeInterval + 5.seconds.timeInterval
//        print("timeInterval === \(timeInterval)")
//        print("toClock === \(timeInterval.toClock())")
        
        /**
         闰年闰月的判断
         */
        let date = Date()
        print("date === \(date)")
        print("是否是闰年：", date.isLeapYear)
        print("是否是闰月：", date.isLeapMonth)
        
        
    }
    
    /// 日期的操作、计算
    func swiftDate4() {
        
//        let date = Date()
//        let date1 = date + 1.years + 1.months + 1.days
//        print("date1 === ", date1)
//        let date2 = date - 1.hours
//        print("date2 === ", date2)
//        let tem = date1 - date
//
//        print("两个日期相差：\(tem.year)年\(tem.month)月\(tem.day)天")
        
        /**
         日期的比较 使用标准数学运算符（>、>=、<、<=、==）比较两个日期。
         */
        
        /**
         let date1 = "2018-12-12 10:30:00".toDate()!.date
         let date2 = "2020-01-01 11:30:00".toDate()!.date
         let date3 = "2020-01-01 11:30:00".toDate()!.date
                  
         print("日期1 >= 日期2：", date1 >= date2)
         print("日期2 == 日期3：", date2 == date3)
         */
        
//        let date1 = "2018-12-12 10:30:00".toDate()!.date
//        let date2 = "2020-01-01 11:30:00".toDate()!.date
//        let date3 = "2020-01-01 11:30:00".toDate()!.date
//
//        print("date1 >= date2", date1 >= date2)
//        print("date2 == date3", date2 == date3)
        
        /**
         指定粒度比较日期
         */
        /**
         let date1 = "2017-12-12 10:30:00".toDate()!.date
         let date2 = "2018-12-01 11:30:00".toDate()!.date
         let date3 = "2018-12-08 10:30:00".toDate()!.date
         print("日期1：\(date1)")
         print("日期2：\(date2)")
         print("日期3：\(date3)")
          
         let result1 = date1.compare(toDate: date2, granularity: .month) == .orderedSame
         print("日期1与日期2年月是否相同：\(result1)")
                  
         let result2 = date1.isBeforeDate(date2, orEqual: false, granularity: .year)
         print("日期1的年份是否在日期2年份前面：\(result2)")
                  
         let result3 = date3.isAfterDate(date2, orEqual: true, granularity: .month)
         print("日期3是否在日期3之后的年月、或者统一年月：\(result3)")
         */
        
//        let date1 = "2018-12-12 10:30:00".toDate()!.date
//        let date2 = "2018-12-01 11:30:00".toDate()!.date
//        let date3 = "2018-12-08 10:30:00".toDate()!.date
//        print("日期1:\(date1)")
//        print("日期1:\(date2)")
//        print("日期1:\(date3)")
//
//        let result1 = date1.compare(toDate: date2, granularity: .month) == .orderedSame
//        print("日期1与日期2的年月是否相同：\(result1)")
//
//        let result2 = date1.isBeforeDate(date2, orEqual: false, granularity: .year)
//        print("日期1的年份是否在日期2年份的前面：\(result2)")
        
        /**
         内置比较
         */
        /**
         let date = "2018-11-22 22:30:00".toDate()!.date
         print("测试日期时间：", date)
         print("")
         print("该日期时间是否是早上：", date.compare(.isMorning))
         print("该日期时间是否是下午：", date.compare(.isAfternoon))
         print("该日期时间是否是傍晚：", date.compare(.isEvening))
         print("该日期时间是否是夜里：", date.compare(.isNight))
         print("")
         print("该日期时间是否是今天：", date.compare(.isToday))
         print("该日期时间是否是明天：", date.compare(.isTomorrow))
         print("该日期时间是否是昨天：", date.compare(.isYesterday))
         print("该日期时间是否是工作日：", date.compare(.isWeekday))
         print("该日期时间是否是周末：", date.compare(.isWeekend))
         print("该日期时间是否是过去的：", date.compare(.isInThePast))
         print("该日期时间是否是将来的：", date.compare(.isInTheFuture))
         print("")
         print("该日期时间是否是本周：", date.compare(.isThisWeek))
         print("该日期时间是否是下周：", date.compare(.isNextWeek))
         print("该日期时间是否是上周：", date.compare(.isLastWeek))
         print("")
         print("该日期时间是否是今年：", date.compare(.isThisYear))
         print("该日期时间是否是明年：", date.compare(.isNextYear))
         print("该日期时间是否是去年：", date.compare(.isLastYear))
         */
        
//        let date = "2018-11-22 22:30:00".toDate()!.date
//        print("date === ", date)
//
//        print("该日期时间是否是早上：", date.compare(.isMorning))
//        print("该日期时间是否是下午：", date.compare(.isAfternoon))
//        print("该日期时间是否是傍晚：", date.compare(.isEvening))
//        print("该日期时间是否是夜里：", date.compare(.isNight))
//        print("")
//        print("该日期时间是否是今天：", date.compare(.isToday))
//        print("该日期时间是否是明天：", date.compare(.isTomorrow))
//        print("该日期时间是否是昨天：", date.compare(.isYesterday))
//        print("该日期时间是否是工作日：", date.compare(.isWeekday))
//        print("该日期时间是否是周末：", date.compare(.isWeekend))
//        print("该日期时间是否是过去的：", date.compare(.isInThePast))
//        print("该日期时间是否是将来的：", date.compare(.isInTheFuture))
//        print("")
//        print("该日期时间是否是本周：", date.compare(.isThisWeek))
//        print("该日期时间是否是下周：", date.compare(.isNextWeek))
//        print("该日期时间是否是上周：", date.compare(.isLastWeek))
//        print("")
//        print("该日期时间是否是今年：", date.compare(.isThisYear))
//        print("该日期时间是否是明年：", date.compare(.isNextYear))
//        print("该日期时间是否是去年：", date.compare(.isLastYear))
        
        /**
         日期的排序，获取首尾日期
         */
        
        let dates = ["2018-11-22 22:30:00".toDate()!,
                     "2017-11-01 01:30:00".toDate()!,
                     "2019-11-01 10:30:00".toDate()!,
                     "1989-10-29 23:12:37".toDate()!,
                     "1977-10-19 03:12:37".toDate()!,
                     "2023-12-10 16:58:36".toDate()!
        ]
        
//        print("dates === ", dates)
        
//        print("降序排序：", DateInRegion.sortedByNewest(list: dates))
//        print("升序排序：", DateInRegion.sortedByOldest(list: dates))
        
        print("最早的一个日期", DateInRegion.oldestIn(list: dates))
        print("最新的一个日期", DateInRegion.newestIn(list: dates))
        
        
    }
    
    /// 生成随机日期
    func swiftDate5() {
        
        /// 1.不指定范围
        let date1 = DateInRegion.randomDate()
        
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
        
        let date2 = DateInRegion.randomDate(region: region)
        print("date1 === ", date1.date)
        print("date2 === ", date2.date)
        
        /// 2.指定范围 (最近五天内的日期)
        let date3 = DateInRegion.randomDate(withinDaysBeforeToday: 5)
        print("date3 === ", date3.date)
        
        /// 3.两个日期之间的随机日期
        let date4 = DateInRegion.randomDate(between: "2020-12-25 13:30:30".toDate()!, and: "2023-12-23 13:30:30".toDate()!)
        print("date4 === ", date4.date)
        
        /// 4.指定范围，随机多个
        let dates = DateInRegion.randomDates(count: 3, between: "2020-12-25 13:30:30".toDate()!, and: "2023-12-23 13:30:30".toDate()!)
        print("dates === ", dates)
        
    }
    
    /// 7.派生和修改时间
    func swiftDate6() {
        
        /// 1.当前日期派生：根据DateInRegion().dateAt()当前时间生成特定时间
//        print("当前时间：", Date())
//        print("")
//        print("今天开始时间：", DateInRegion().dateAt(.startOfDay).date)
//        print("今天结束时间：", DateInRegion().dateAt(.endOfDay).date)
//        print("本周开始时间：", DateInRegion().dateAt(.startOfWeek).date)
//        print("本周结束时间：", DateInRegion().dateAt(.endOfWeek).date)
//        print("本月开始时间：", DateInRegion().dateAt(.startOfMonth).date)
//        print("本月结束时间：", DateInRegion().dateAt(.endOfMonth).date)
//        print("")
//        print("昨天这个时间：", DateInRegion().dateAt(.yesterday).date)
//        print("昨天开始时间：", DateInRegion().dateAt(.yesterdayAtStart).date)
//        print("明天这个时间：", DateInRegion().dateAt(.tomorrow).date)
//        print("明天开始时间：", DateInRegion().dateAt(.tomorrowAtStart).date)
//        print("")
//        print("上周开始时间：", DateInRegion().dateAt(.prevWeek).date)
//        print("上月开始时间：", DateInRegion().dateAt(.prevMonth).date)
//        print("去年开始时间：", DateInRegion().dateAt(.prevYear).date)
//        print("下周开始时间：", DateInRegion().dateAt(.nextWeek).date)
//        print("下月开始时间：", DateInRegion().dateAt(.nextMonth).date)
//        print("明年开始时间：", DateInRegion().dateAt(.nextYear).date)

        /// dateAtStartOf() dateAtEndOf() 根据一个指定日期时间来分别获取相应的开始、结束时间
//        let date1 = "2018-12-14 08:30:00".toDate()!
//        print("指定日期：", date1.date)
//        print("指定日期当天的开始时间：", date1.dateAtStartOf(.day).date)
//        print("指定日期当天的结束时间：", date1.dateAtEndOf(.day).date)
//        print("指定日期当月的开始时间：", date1.dateAtStartOf(.month).date)
//        print("指定日期当月的结束时间：", date1.dateAtEndOf(.month).date)
//        print("指定日期当年的开始时间：", date1.dateAtStartOf(.year).date)
//        print("指定日期当年的结束时间：", date1.dateAtEndOf(.year).date)
        
        /// 通过 dateBySet() 方法可以重置（修改）一个时间的部分内容。比如下面将时分秒部分都设置为 10
//        let date = "2018-12-12 08:37:57".toDate()!
//        print("原日期时间：", date.date)
//        let date1 = date.dateBySet(hour: 10, min: 17, secs: 27)!
//        print("新日期时间：", date1.date)
        
        /// 通过 dateTruncated() 方法可以将一个时间的部分清除
        let date = "2018-12-12 08:37:57".toDate()!
        print("原日期时间：", date.date)
        let date1 = date.dateTruncated(at: [.hour, .minute, .second])!
        print("新日期时间：", date1.date)
        
        
    }
    
}

/** 序列化和反序列化
 序列化：把对象转化成字节序列的过程，称为序列化
 反序列化：把字节序列转化成对象，称为发序列化
 */

/// 主要目的：是网络传输对象数据，或者将对象存储到文件系统，数据库、内存中
