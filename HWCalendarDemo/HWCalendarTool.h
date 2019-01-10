//
//  HWCalendarTool.h
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/10.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWCalendarTool : NSObject

/**
 * 返回date日期在日历UI中的位置下标
 * calender 日历对象
 * currentDate 当前NSDate 对象 [NSDate new]
 */
+ (NSInteger)getTodayDateIndexfromCalendar:(NSCalendar *)calender fromDate:(NSDate *)currentDate;

/**
 * 获取目标月的1号date对象
 * calender 日历对象
 * date 当前时间
 * number 当前月之后几个月的1号
 */
+ (NSDate *)getAMonthfromCalender:(NSCalendar *)calender fromDate:(NSDate*)date months:(NSInteger)number;

/**
 * 获取某个月的1号是星期几
 * calender 日历对象
 * date 目标月的date
 */
+ (NSInteger)firstDayInWeekForMonthOfCalender:(NSCalendar *)calender fromData:(NSDate*)date;

/**
 *  获取当前月天数
 */
+ (NSInteger)getCurrentMonthForDays;

/*
 * 获取某个月一共多少天
 * date 要获取的月份的date
 */
+ (NSInteger)getAllDaysForMonth:(NSDate *)date;

/**
 * 日期转字符串
 * date:需要转换的日期
 */
+ (NSString *)getTargetDateConversionStr:(NSDate * )date;

@end

NS_ASSUME_NONNULL_END
