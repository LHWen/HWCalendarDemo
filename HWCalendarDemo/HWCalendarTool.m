//
//  HWCalendarTool.m
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/10.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import "HWCalendarTool.h"

@implementation HWCalendarTool

/**
 * 返回date日期在日历UI中的位置下标
 * calender 日历对象
 * currentDate 当前NSDate 对象 [NSDate new]
 */
+ (NSInteger)getTodayDateIndexfromCalendar:(NSCalendar *)calender fromDate:(NSDate *)currentDate {
    
    NSDate *amountDate = [self getAMonthfromCalender:calender fromDate:currentDate months:0];
    NSCalendarUnit dayinfoUnits = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calender components:dayinfoUnits fromDate:currentDate];
    
    // components.day 对应今天对应日历号下标（比如：9号 -> 9）由于数组下标从0开始，所以需要 -1
    NSInteger index = components.day - 1 + [self firstDayInWeekForMonthOfCalender:calender fromData:amountDate];
    return index;
}

/**
 * date :当前时间
 * number:当前月之后几个个月的1号date
 */
+ (NSDate *)getAMonthfromCalender:(NSCalendar *)calender fromDate:(NSDate*)date months:(NSInteger)number {
    
    NSCalendarUnit dayInfoUnits = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calender components:dayInfoUnits fromDate:date];
    components.day = 1;
    if (number != 0) {
        components.month += number;
    }
    NSDate *nextMonthDate = [calender dateFromComponents:components];
    
    return nextMonthDate;
}

/**
 * 获取某个月的1号是星期几
 * date 目标月的date
 */
+ (NSInteger)firstDayInWeekForMonthOfCalender:(NSCalendar *)calender fromData:(NSDate*)date {
    
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [comps weekday];
    // 日历从 周日 - 周六显示 下标要前移动一位
    weekday--;
    if (weekday == 7) {
        return 0;
    } else {
        return weekday;
    }
}

/**
 *  获取当前月天数
 */
+ (NSInteger)getCurrentMonthForDays {
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange range = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    return numberOfDaysInMonth;
}

/*
 * 获取某个月一共多少天
 * date 要获取的月份的date
 */
+ (NSInteger)getAllDaysForMonth:(NSDate *)date {
    NSInteger monthNum = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    return monthNum;
}

// 日期转字符串
+ (NSString * )getTargetDateConversionStr:(NSDate * )date {
    
    // 实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    // 设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    // 根据自己需求处理字符串 字符串剪切
    return [currentDateStr substringToIndex:7];
}

@end
