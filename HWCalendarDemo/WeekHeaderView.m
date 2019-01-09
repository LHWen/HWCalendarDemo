//
//  WeekHeaderView.m
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/8.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import "WeekHeaderView.h"

@implementation WeekHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
        [self p_setWeekLableLayout];
    }
    return self;
}

- (void)p_setWeekLableLayout {
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    CGFloat kDayWidth = self.frame.size.width / weekArray.count;
    
    for (int i = 0; i < weekArray.count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(i * kDayWidth, 0, kDayWidth, CGRectGetHeight(self.frame))];
        lable.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        lable.text = weekArray[i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = UIColor.orangeColor;
        [self addSubview:lable];
    }
}

@end
