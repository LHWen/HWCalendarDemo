//
//  CalendarCollectionViewCell.m
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/8.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import "CalendarCollectionViewCell.h"
#import "Masonry/Masonry.h"

@interface CalendarCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabl;
@property (nonatomic, strong) UILabel *disLabl;
@property (nonatomic, strong) UIView *bgVeiw;
@property (nonatomic, strong) UIView *line;

@end

@implementation CalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self p_setContentViewLayout];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor {
    
    _bgVeiw.backgroundColor = bgColor;
    _titleLabl.backgroundColor = bgColor;
    _disLabl.backgroundColor = bgColor;
    [self setNeedsDisplay];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabl.text = titleStr;
    if (titleStr.length <= 0) {
        _line.hidden = YES;
    } else {
        _line.hidden = NO;
    }
    [_titleLabl setNeedsDisplay];
    [_line setNeedsDisplay];
}

- (void)setDisStr:(NSString *)disStr {
    _disLabl.text = disStr;
    [_titleLabl setNeedsDisplay];
}

- (void)p_setContentViewLayout {
    
    if (!_titleLabl) {
        
        _bgVeiw = [[UIView alloc] init];
        _bgVeiw.backgroundColor = UIColor.whiteColor;
        _bgVeiw.layer.cornerRadius = (CGRectGetWidth(self.bounds) / 2.0 - 3.0);
        _bgVeiw.layer.masksToBounds = YES;
        [self addSubview:_bgVeiw];
        [_bgVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@3.0);
            make.bottom.right.equalTo(@(-3.0));
        }];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@0.5f);
        }];
        
        _titleLabl = [[UILabel alloc] init];
        _titleLabl.backgroundColor = UIColor.whiteColor;
        _titleLabl.text = @" ";
        _titleLabl.font = [UIFont systemFontOfSize:14];
        _titleLabl.textColor = UIColor.blackColor;
        [self addSubview:_titleLabl];
        [_titleLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        _disLabl = [[UILabel alloc] init];
        _disLabl.backgroundColor = UIColor.whiteColor;
        _disLabl.text = @" ";
        _disLabl.font = [UIFont systemFontOfSize:11];
        _disLabl.textColor = UIColor.blueColor;
        [self addSubview:_disLabl];
        [_disLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(@(-5));
        }];
    }
}

@end
