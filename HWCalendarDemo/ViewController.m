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
#import "HWCalendarTool.h"

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
    _selectedIndex = [HWCalendarTool getTodayDateIndexfromCalendar:_calender fromDate:_currentDate];
    
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
    
    // 获取目标月的1号date对象
    NSDate *amonthOfDate = [HWCalendarTool getAMonthfromCalender:_calender fromDate:_currentDate months:section];
    // 装collectionView头视图需要的数据
    [_headerViewDataArray addObject:amonthOfDate];
    // 目标月的天数+星期数（这天星期几就加几）---目的->布局cell时候能够让每个月1号对应上星期数
    
    NSInteger monthDays = 0;
    NSInteger firstDayInWeek = [HWCalendarTool firstDayInWeekForMonthOfCalender:_calender fromData:amonthOfDate];
    if (section == 0) {
        monthDays = [HWCalendarTool getCurrentMonthForDays] + firstDayInWeek;
    } else {
        monthDays = [HWCalendarTool getAllDaysForMonth:amonthOfDate] + firstDayInWeek;
    }
    
    return monthDays;
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
    
    NSDate *amountOf1_Date = [HWCalendarTool getAMonthfromCalender:_calender fromDate:_currentDate months:indexPath.section];
    // 获取该月第一天是周几,
    NSInteger indexNumber = [HWCalendarTool firstDayInWeekForMonthOfCalender:_calender fromData:amountOf1_Date];
    if (indexPath.item < indexNumber) {
        // item index 小于 该月 1号的 index 显示空白
        item.titleStr = @"";
        item.disStr = @"";
        item.bgColor = UIColor.whiteColor;
    } else {
        NSString * calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item + 1 - indexNumber)];
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
    // 还原被点击出的背景色
    if (_selectedIndexPath) {
        cell = (CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:_selectedIndexPath];
        cell.bgColor = UIColor.whiteColor;
    }
    
    // 设置点击出颜色背景
    _selectedIndexPath = indexPath;
    cell = (CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgColor = UIColor.redColor;
    
    // 设置点击空白处空白处颜色还原
    NSDate *amountOfDate = [HWCalendarTool getAMonthfromCalender:_calender fromDate:_currentDate months:indexPath.section];
    NSInteger indexNumber = [HWCalendarTool firstDayInWeekForMonthOfCalender:_calender fromData:amountOfDate];
    if (indexPath.item < indexNumber) {
        cell.bgColor = UIColor.whiteColor;
    }
    
    // today item backgroundColor
    if (indexPath.section == 0 && _selectedIndexPath.item != _selectedIndex) {
        cell = (CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
        cell.bgColor = UIColor.yellowColor;
    }
}

// 设置head foot视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderView forIndexPath:indexPath];
        headerView.yearerLabel.text = [HWCalendarTool getTargetDateConversionStr:_headerViewDataArray[indexPath.section]];
        return headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterView forIndexPath:indexPath];
        footerView.backgroundColor = UIColor.whiteColor;
        return footerView;
    }
    return nil;
}

@end
