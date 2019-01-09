//
//  CalendarCollectionViewCell.h
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/8.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *disStr;
@property (nonatomic, strong) UIColor *bgColor;

@end

NS_ASSUME_NONNULL_END
