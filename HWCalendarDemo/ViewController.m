//
//  ViewController.m
//  HWCalendarDemo
//
//  Created by LHWen on 2019/1/8.
//  Copyright © 2019 LHWen. All rights reserved.
//

#import "ViewController.h"
#import "WeekHeaderView.h"
#import "CollectionHeaderView.h"
#import "CalendarCollectionViewCell.h"

#define  kScreenWidth [UIScreen mainScreen].bounds.size.width

static NSString * const kCalendarCell = @"kCalendarCollectionViewCell";
static NSString * const kHeaderView = @"kCollectionHeaderView";
static NSString * const kFooterView = @"kCollectionFooterView";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) WeekHeaderView *weekHeaderView; // 周头部视图
@property (nonatomic, strong) NSCalendar *calender; // 日历
@property (nonatomic, strong) NSDate *currentDate; // 当前日期
@property (nonatomic, assign) NSInteger selectedIndex; // 当前选择
@property (nonatomic, assign) NSInteger firstWeekday;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *headerViewDataArray;

@end

@implementation ViewController

- (WeekHeaderView *)weekHeaderView {
    if (!_weekHeaderView) {
        _weekHeaderView = [[WeekHeaderView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 30.0f)];
    }
    return _weekHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"日历";
    self.view.backgroundColor = UIColor.whiteColor;
    
    _headerViewDataArray = [NSMutableArray array];
    _calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _currentDate = [NSDate new];
    _selectedIndex = [self p_getTheDateInCalendarTodaySubscript];
    
    [self.view addSubview:self.weekHeaderView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.5;  // 左右中间间隔距离
    flowLayout.minimumLineSpacing = 0.5;       // 选项间上下距离间距
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
    flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 0);
    flowLayout.sectionHeadersPinToVisibleBounds = YES; // header 悬浮
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 94, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 94) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:kCalendarCell];
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView];
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView];
    [self.view addSubview:self.collectionView];
}

#pragma mark -- collectionDelegateAndDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //     获取目标月的1月1号date对象（方法自己封装的，适合我这个使用,可以根据上述方法自己修改）
    NSDate *amonthOfDate = [self p_getAMonthframDate:_currentDate months:section];
    // 装collectionView头视图需要的数据
    [_headerViewDataArray addObject:amonthOfDate];
    // 目标月的天数+星期数（这天星期几就加几）---目的->布局cell时候能够让每个月1号对应上星期数
    
    NSInteger monthDays = 0;
    if (section == 0) {
        monthDays = [self p_getCurrentMonthForDays] + [self p_getFirstDayWeekForMonth:amonthOfDate];
    } else {
        monthDays = [self getNextNMonthForDays:amonthOfDate] + [self p_getFirstDayWeekForMonth:amonthOfDate];
    }
    
    return monthDays;
}

/**
 *  返回今天日期在日历UI中的位置下标
 */
- (NSInteger)p_getTheDateInCalendarTodaySubscript {
    
    NSDate *amountDate = [self p_getAMonthframDate:_currentDate months:0];
    NSCalendarUnit dayinfoUnits = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [_calender components:dayinfoUnits fromDate:_currentDate];
    
//    NSLog(@"当前日期的comps=%@ ---- %ld",components,(long)[self p_getFirstDayWeekForMonth:amountDate]);
    NSLog(@"components.day: %ld", components.day);
    // components.day 对应今天对应日历号下标（比如：9号 - 9）由于数组下标从0开始，所以需要 -1
    return components.day - 1 + [self p_getFirstDayWeekForMonth:amountDate];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCell forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.item == _selectedIndex) {
        // 某个月的1号Date对象 (这个case中是当前月)
        if (indexPath.item == _selectedIndex) {
            item.bgColor = UIColor.yellowColor;
        }
    } else if (indexPath == _selectedIndexPath) {
        item.bgColor = UIColor.redColor;
    } else {
        item.bgColor = UIColor.whiteColor;
    }
    
    NSDate *amountOf1_Date = [self p_getAMonthframDate:_currentDate months:indexPath.section];
    if (indexPath.item < [self p_getFirstDayWeekForMonth:amountOf1_Date]) {
        item.titleStr = @"";
        item.disStr = @"";
        item.bgColor = UIColor.whiteColor;
    } else {
        /*
         *  getFirstDayWeekForMonth ->获取目标月份1号是周几
         *  [self getAMonthframDate:currentDate months:0] ->根据当前日期返回目标月1号的date对象(用来计算1号周几)
         *  case1,2,3,4 同理!
         *******/
        // 给item赋值indexPath.item - 第一天是周几 就可以知道这个月日期怎么赋值了
        NSInteger number;
        NSString * calenderStr;
        // 方法定义如果是星期天返回0(为了日历布局) 所以这里处理一下
        if ([self p_getFirstDayWeekForMonth:amountOf1_Date] == 0){
            calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item + 1)];
        }else{
            number = [self p_getFirstDayWeekForMonth:amountOf1_Date];
            calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item + 1 - number)];
        }
        item.titleStr = calenderStr;
        item.disStr = [NSString stringWithFormat:@"¥%ld", (NSInteger)((arc4random() % 10) + 20)];
    }
    return item;
}

// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 3) / 7, (kScreenWidth - 3) / 7);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarCollectionViewCell *cell;
    if (_selectedIndexPath) {
        cell = (CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:_selectedIndexPath];
        cell.bgColor = UIColor.whiteColor;
    }
    _selectedIndexPath = indexPath;
    cell = (CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgColor = UIColor.redColor;
    
    if (indexPath.section == 0 && _selectedIndexPath.item != _selectedIndex) {
        cell = (CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
        cell.bgColor = UIColor.yellowColor;
    }
}

// 设置head foot视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderView forIndexPath:indexPath];
        headerView.yearerLabel.text = [self theTargetDateConversionStr:_headerViewDataArray[indexPath.section]];
        return headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterView forIndexPath:indexPath];
        footerView.backgroundColor = UIColor.whiteColor;
        return footerView;
    }
    return nil;
}

/**
 *  获取当前月天数
 */
- (NSInteger)p_getCurrentMonthForDays {
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange range = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    NSLog(@"nsrange = %@----- %ld",NSStringFromRange(range),range.location);
    return numberOfDaysInMonth;
}

/**
 * date :当前时间
 * number:当前月之后几个个月的1号date
 */
- (NSDate *)p_getAMonthframDate:(NSDate*)date months:(NSInteger)number {
    
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [_calender components:dayInfoUnits fromDate:date];
    components.day = 1;
    if (number != 0) {
        components.month += number;
    }
    NSDate * nextMonthDate = [_calender dateFromComponents:components];
    return nextMonthDate;
}

/*
 * 获取某个月一共多少天
 * date 要获取的月份的date
 */
- (NSInteger)getNextNMonthForDays:(NSDate *)date {
    NSInteger monthNum =[[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    return monthNum;
}

/**
 * 获取某个月的1号是星期几
 * date 目标月的date
 **/
- (NSInteger)p_getFirstDayWeekForMonth:(NSDate*)date {

    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [_calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSLog(@"comps是这个样子的:%@",comps);
    NSInteger weekday = [comps weekday];
    weekday--;  // 日历从 周日 - 周六显示 下标要前移动一位
    NSLog(@"[comps weekday] = %ld",(long)weekday);
    if (weekday == 7) {
        return 0;
    } else {
        return weekday;
    }
}

/**
 * 日期转字符串
 * date:需要转换的日期
 */
- (NSString * )theTargetDateConversionStr:(NSDate * )date {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init]; // 实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    // 根据自己需求处理字符串 字符串剪切
    return [currentDateStr substringToIndex:7];
}

@end
