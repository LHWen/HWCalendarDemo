//
//  CollectionHeaderView.m
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/8.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.3];
        self.yearerLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.yearerLabel.textColor = [UIColor darkGrayColor];
        self.yearerLabel.textAlignment = NSTextAlignmentCenter;
        self.yearerLabel.font = [UIFont systemFontOfSize:15];
        self.yearerLabel.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
        [self addSubview:_yearerLabel];
    }
    return self;
}

@end
