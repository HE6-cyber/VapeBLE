//
//  DataViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DataViewController.h"
#import "DataViewControllerHelper.h"
#import "PMCalendar.h"
#import "SyncDataHelper.h"

typedef NS_ENUM(NSInteger, CollectionViewTagValue) {
    CollectionViewTagValueHour      = 300001,
    CollectionViewTagValueDay       = 300002,
    CollectionViewTagValueMonth     = 300003,
    CollectionViewTagValueYear      = 300004
};

@interface DataViewController () <TcpCommandHelperDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, BarChartCellDelegate, SyncDataHelperDelegate> {
    
    DataViewControllerHelper        *helper;
    
    BOOL                            isFirstShowedForSelfView; //是否是第一次显示本控制器的self.view
    
    NSInteger                       selectedHourPageIndex;
    NSInteger                       selectedDayPageIndex;
    NSInteger                       selectedMonthPageIndex;
    NSInteger                       selectedYearPageIndex;
   
    
}

@property (strong, nonatomic) NSMutableArray    *currentUploadedSmokingDataIds;
@property (strong, nonatomic) NSMutableArray    *currentUploadedSmokingLocationDataIds;
@property (strong, nonatomic) NSMutableArray    *currentUploadedHeartRateDataIds;


//==================小时、日、月、年的UICollectionView===============
@property (weak, nonatomic) IBOutlet UIView *collectionsBackView;

@property (weak, nonatomic) IBOutlet UICollectionView *hourCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *dayCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *yearCollectionView;
//===============================================================

//==============小时、日、月、年的UIImageView、UIButton==============
@property (weak, nonatomic) IBOutlet UIImageView *hourImgView;
@property (weak, nonatomic) IBOutlet UIImageView *dayImgView;
@property (weak, nonatomic) IBOutlet UIImageView *monthImgView;
@property (weak, nonatomic) IBOutlet UIImageView *yearImgView;


- (IBAction)onHourButton:(UIButton *)sender;
- (IBAction)onDayButton:(UIButton *)sender;
- (IBAction)onMonthButton:(UIButton *)sender;
- (IBAction)onYearButton:(UIButton *)sender;
//===============================================================


//==========================吸烟口数、次数、情况=====================
@property (weak, nonatomic) IBOutlet UILabel *smokingPuffsLabel;
@property (weak, nonatomic) IBOutlet UILabel *smokingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *smokingStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *smokingPuffsButton;
@property (weak, nonatomic) IBOutlet UIButton *smokingTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *smokingStatusButton;

- (IBAction)onSmokingPuffsButton:(UIButton *)sender;
- (IBAction)onSmokingTimeButton:(UIButton *)sender;
//===============================================================

- (IBAction)onSmokingLocationButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLine1WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLine2WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLine3WidthConstraint;


@end

@implementation DataViewController

//==========================================================================================================================
#pragma mark - 控制器生命周期方法
//==========================================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyData);
    helper = [[DataViewControllerHelper alloc] init]; //这个必须放在前面
    [self setupBorderLineConstraint];
    [self setupSyncButtonInLeftBarButtonItem];
    [self setupShareButtonInRightBarButtonItem];

    isFirstShowedForSelfView = YES;
    selectedHourPageIndex   = [helper actualHourBarCount] - 1;
    selectedDayPageIndex    = [helper actualDayBarCount] - 1;
    selectedMonthPageIndex  = [helper actualMonthBarCount] - 1;
    selectedYearPageIndex   = [helper actualYearBarCount] - 1;
    [self setSmokingPuffsAndTimeAndStatusBySmokingData:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setCurrentTimeSegmentType:SmokingTimeSegmentTypeHour];
    [self showChartByStatisticsType:SmokingStatisticsTypeSmokingPuffs];
//    [self test];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //==============================================================================================
    if (isFirstShowedForSelfView) {  //在控制器的生命周期中，只有第一次进入显示界面才调用下面的方法
        isFirstShowedForSelfView = NO;
        [self.hourCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([helper actualHourBarCount] - 1) inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionRight
                                                animated:NO];
        [self.dayCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([helper actualDayBarCount] - 1) inSection:0]
                                       atScrollPosition:UICollectionViewScrollPositionRight
                                               animated:NO];
        [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([helper actualMonthBarCount] - 1) inSection:0]
                                         atScrollPosition:UICollectionViewScrollPositionRight
                                                 animated:NO];
        [self.yearCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([helper actualYearBarCount] - 1) inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionRight
                                                animated:NO];
        [self.collectionsBackView bringSubviewToFront:self.hourCollectionView];
        SmokingStatistics *smokingData = [helper getHourSmokingDataByPageIndex:selectedHourPageIndex];
        [self setSmokingPuffsAndTimeAndStatusBySmokingData:smokingData];
        
    }
    else {
        [self refreshChartsByCollectionView:[[self.collectionsBackView subviews] lastObject]];
    }
    //==============================================================================================
    
    DebugLog(@"Document Dir : %@", [Utility applicationDocumentsDirectory]);
//    NSDate *date = [SmokingDataAccessor getMinimumSmokingDtByUserId:1053169];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//
- (void)test {
    
    NSDate *startDate = [NSDate date];
    
    for (int i=0; i<365*24; i++) {
        
        Smoking *smoking = [[Smoking alloc] init];
        smoking.userId = [UserHelper currentUserId];
        smoking.smokingDt = startDate;
        smoking.smokingId = [IDGenerator generateSmokingDataIdByDate:smoking.smokingDt];
        smoking.hourIndex = [IDGenerator generateHourIndexByDate:smoking.smokingDt];
        smoking.dayIndex = [IDGenerator generateDayIndexByDate:smoking.smokingDt];
        smoking.monthIndex = [IDGenerator generateMonthIndexByDate:smoking.smokingDt];
        smoking.yearIndex = [IDGenerator generateYearIndexByDate:smoking.smokingDt];
        smoking.smokingTime = (arc4random()*100) % 100;
        smoking.numberOfPuffs = smoking.smokingTime > 0 ? 1 : 0;
        DebugLog(@"----------------------%ld-------------------------", (long)smoking.hourIndex);
        [SmokingDataAccessor saveSmoking:smoking];
        startDate = [startDate offsetHours:-1];
        
    }
    
    DebugLog(@"------------------%@------------------------YES", startDate);
    
}



//==========================================================================================================================
#pragma mark - 辅助方法
//==========================================================================================================================
/**
 * 设置边框线的约束
 **/
- (void)setupBorderLineConstraint {
    self.centerLine1WidthConstraint.constant    = kBorder_Line_Width;
    self.centerLine2WidthConstraint.constant    = kBorder_Line_Width;
    self.centerLine3WidthConstraint.constant    = kBorder_Line_Width;
    
    self.smokingPuffsButton.layer.borderColor   = kNavigationBar_Bg_Color.CGColor;
    self.smokingPuffsButton.layer.borderWidth   = kBorder_Line_Width;
    self.smokingPuffsButton.layer.cornerRadius  = 15;
    self.smokingTimeButton.layer.borderColor    = kNavigationBar_Bg_Color.CGColor;
    self.smokingTimeButton.layer.borderWidth    = kBorder_Line_Width;
    self.smokingTimeButton.layer.cornerRadius   = 15;
    self.smokingStatusButton.layer.borderColor    = kNavigationBar_Bg_Color.CGColor;
    self.smokingStatusButton.layer.borderWidth    = kBorder_Line_Width;
    self.smokingStatusButton.layer.cornerRadius   = 15;
}


/**
 * 设置当前时间段类型并刷新界面
 **/
- (void)setCurrentTimeSegmentType:(SmokingTimeSegmentType)timeSegmentType {
    helper.timeSegmentType = timeSegmentType;
    
    BOOL isHideHourImgView   = YES;
    BOOL isHideDayImgView   = YES;
    BOOL isHideMonthImgView = YES;
    BOOL isHideYearImgView  = YES;
    switch (timeSegmentType) {
        case SmokingTimeSegmentTypeHour:
            isHideHourImgView = NO;
            break;
        case SmokingTimeSegmentTypeDay:
            isHideDayImgView = NO;
            break;
        case SmokingTimeSegmentTypeMonth:
            isHideMonthImgView = NO;
            break;
        case SmokingTimeSegmentTypeYear:
            isHideYearImgView = NO;
            break;
    }
    [self.hourImgView   setHidden:isHideHourImgView];
    [self.dayImgView    setHidden:isHideDayImgView];
    [self.monthImgView  setHidden:isHideMonthImgView];
    [self.yearImgView   setHidden:isHideYearImgView];
}



/**
 * 设置当前吸烟统计类型并刷新界面
 **/
- (void)showChartByStatisticsType:(SmokingStatisticsType)statisticsType {
    helper.statisticsType = statisticsType;
    
    UIColor *smokingPuffsButtonBgColor          = [UIColor whiteColor];
    UIColor *smokingPuffsButtonTitleColor       = kNavigationBar_Bg_Color;
    UIColor *smokingTimesButtonBgColor          = [UIColor whiteColor];
    UIColor *smokingTimesButtonTitleColor       = kNavigationBar_Bg_Color;
//    switch (statisticsType) {
//        case SmokingStatisticsTypeSmokingPuffs:
//            smokingPuffsButtonBgColor = kNavigationBar_Bg_Color;
//            smokingPuffsButtonTitleColor = [UIColor whiteColor];
//            break;
//        case SmokingStatisticsTypeSmokingTime:
//            smokingTimesButtonBgColor = kNavigationBar_Bg_Color;
//            smokingTimesButtonTitleColor = [UIColor whiteColor];
//            break;
//    }
    [self.smokingPuffsButton    setBackgroundColor:smokingPuffsButtonBgColor];
    [self.smokingPuffsButton    setTitleColor:smokingPuffsButtonTitleColor      forState:UIControlStateNormal];
    [self.smokingTimeButton    setBackgroundColor:smokingTimesButtonBgColor];
    [self.smokingTimeButton    setTitleColor:smokingTimesButtonTitleColor      forState:UIControlStateNormal];
    
}

- (void)setSmokingPuffsAndTimeAndStatusBySmokingData:(SmokingStatistics *)smokingData {
    if (smokingData != nil) {
        //显示吸烟口数
        self.smokingPuffsLabel.text = [NSString stringWithFormat:@"%ld%@", (long)smokingData.numberOfPuffs, LOCALIZED_STRING(keyUnitPuffs)];
        
        //显示吸烟时间
        self.smokingTimeLabel.text = [Utility timeStringBySeconds:smokingData.smokingTime];
        
        //=====================计算吸烟情况========================
        NSInteger puffsPerDay = 0;
        NSString *indexString = [NSString stringWithFormat:@"%ld", (long)smokingData.index];
        SmokingStatistics *dbReturn;
        switch (smokingData.indexType) {
            case SmokingDataIndexTypeHour: {
                NSString *hourIndexString = [NSString stringWithFormat:@"%@%@%@",
                                             [indexString substringWithRange:NSMakeRange(0, 4)],
                                             [indexString substringWithRange:NSMakeRange(4, 2)],
                                             [indexString substringWithRange:NSMakeRange(6, 2)]];
                dbReturn = [SmokingDataAccessor selectDayStatisticsByDayIndex:[hourIndexString integerValue] UserId:[UserHelper currentUserId]];
                if (dbReturn != nil) {
                    puffsPerDay = dbReturn.numberOfPuffs;
                }
            }
                break;
            case SmokingDataIndexTypeDay: {
                puffsPerDay = smokingData.numberOfPuffs;
            }
                break;
            case SmokingDataIndexTypeMonth: {
                NSString *monthIndexString = [NSString stringWithFormat:@"%@%@",
                                             [indexString substringWithRange:NSMakeRange(0, 4)],
                                             [indexString substringWithRange:NSMakeRange(4, 2)]];
                dbReturn = [SmokingDataAccessor selectMonthStatisticsByMonthIndex:[monthIndexString integerValue] UserId:[UserHelper currentUserId]];
                NSInteger month = [[indexString substringWithRange:NSMakeRange(4, 2)] integerValue];
                if (dbReturn != nil) {
                    if ([[NSDate date] month] == month) { //当月
                        puffsPerDay = dbReturn.numberOfPuffs / ([[NSDate date] day]); //当月吸烟总口数/当月已过天数
                    }
                    else { //其他月
                        NSDate *smokingMonthFirstDay = [NSDate dateByYear:[[indexString substringWithRange:NSMakeRange(0, 4)] integerValue]
                                                                    Month:[[indexString substringWithRange:NSMakeRange(4, 2)] integerValue] Day:1];
                        puffsPerDay = dbReturn.numberOfPuffs / [smokingMonthFirstDay numDaysInMonth]; // 月总吸烟口数/月总天数
                    }
                }
            }
                break;
            case SmokingDataIndexTypeYear: {
                NSInteger yearIndex = [[indexString substringWithRange:NSMakeRange(0, 4)] integerValue];
                dbReturn = [SmokingDataAccessor selectYearStatisticsByYearIndex:yearIndex UserId:[UserHelper currentUserId]];
                if (dbReturn != nil) {
                    NSDate *beginDate = [NSDate dateByYear:yearIndex Month:1 Day:1];
                    NSDate *endDate =  nil;
                    if ([[NSDate date] year] == yearIndex) {
                        endDate = [NSDate date];
                    }
                    else {
                        endDate = [[beginDate offsetYear:1] offsetDay:-1];
                    }
                   NSInteger dayCount = [[NSDate sharedCalendar] components:NSCalendarUnitDay
                                                                   fromDate:[NSDate dateStartOfDay:beginDate]
                                                                     toDate:[NSDate dateEndOfDay:endDate] options:0].day;
                    puffsPerDay = dbReturn.numberOfPuffs / dayCount;
                }
  
            }
                break;
        }
        //==========================
        //少量：0 ~ 50口(含)
        //较多:50 ~ 100(含)
        //过量：100口以上
        //=========================
        NSString *smokingAmountString = nil;
        if (puffsPerDay <= 50) {
            smokingAmountString = LOCALIZED_STRING(keyFew);//@"少量"
        }
        else if (puffsPerDay > 50 && puffsPerDay <= 100) {
            smokingAmountString = LOCALIZED_STRING(keyMore);//@"较多"
        }
        else {
            smokingAmountString = LOCALIZED_STRING(keyOverdose);//@"过量"
        }
        //吸烟情况
        self.smokingStatusLabel.text = smokingAmountString;
    }
    else {
        self.smokingPuffsLabel.text     = [NSString stringWithFormat:@"0%@", LOCALIZED_STRING(keyUnitPuffs)];
        self.smokingTimeLabel.text      = [Utility timeStringBySeconds:0];;
        self.smokingStatusLabel.text    = LOCALIZED_STRING(keyFew);//@"少量"
    }

}

//==========================================================================================================================
#pragma mark - 切换刷新图表的相关方法
//==========================================================================================================================
/**
 * 返回指定CollectionView中最后一个可见单元格的页码
 **/
- (NSInteger)getPageNumberOfLastVisibleCellInCollectionView:(UICollectionView *)collectionView {
    NSArray *visibleCells = [collectionView visibleCells];
    NSInteger lastPageIndex = (kNumber_Of_Bars_In_OtherChartView-1);
    for (BarChartCell *cell in visibleCells) {
        if (cell.pageNumber > lastPageIndex) {
            lastPageIndex = cell.pageNumber;
        }
    }
    return lastPageIndex;
}

/**
 * 刷新图表
 **/
- (void)refreshChartsByCollectionView:(UICollectionView *)collectionView {

    switch (collectionView.tag) {
        case CollectionViewTagValueHour: {
            [self.collectionsBackView bringSubviewToFront:self.hourCollectionView];
            [helper refreshHourDataSource];
            [self.hourCollectionView reloadData];
            SmokingStatistics *smokingData = [helper getHourSmokingDataByPageIndex:selectedHourPageIndex];
            [self setSmokingPuffsAndTimeAndStatusBySmokingData:smokingData];
        }
            break;
        case CollectionViewTagValueDay: {
            [self.collectionsBackView bringSubviewToFront:self.dayCollectionView];
            [helper refreshDayDataSource];
            [self.dayCollectionView reloadData];
            SmokingStatistics *smokingData = [helper getDaySmokingDataByPageIndex:selectedDayPageIndex];
            [self setSmokingPuffsAndTimeAndStatusBySmokingData:smokingData];
        }
            break;
        case CollectionViewTagValueMonth: {
            [self.collectionsBackView bringSubviewToFront:self.monthCollectionView];
            [helper refreshMonthDataSource];
            [self.monthCollectionView reloadData];
            SmokingStatistics *smokingData = [helper getMonthSmokingDataByPageIndex:selectedMonthPageIndex];
            [self setSmokingPuffsAndTimeAndStatusBySmokingData:smokingData];
        }
            break;
        case CollectionViewTagValueYear: {
            [self.collectionsBackView bringSubviewToFront:self.yearCollectionView];
            [helper refreshYearDataSource];
            [self.yearCollectionView reloadData];
            SmokingStatistics *smokingData = [helper getYearSmokingDataByPageIndex:selectedYearPageIndex];
            [self setSmokingPuffsAndTimeAndStatusBySmokingData:smokingData];
        }
            break;
    }

}


//=====================================================================================
#pragma mark - 通知处理方法
//=====================================================================================
- (void)handleBLENotification:(NSNotification *)notification {
    [super handleBLENotification:notification];
    BLEMessage *message = [notification.userInfo objectForKey:kUserInfo_Key_Message];
    
    switch (message.notificationCode) {
        case BLENotificationCodeDiscoverPeripheral: {
            
        }
            break;
        case BLENotificationCodeSucceedToConnectPeripheral: {
            
        }
            break;
        case BLENotificationCodeInitPeripheralCompleted: {
            
        }
            break;
        case BLENotificationCodeReceiveNotifyForCharacteristic: {
//            if (message.bleOpCode == BLEOperationCodeBindDevice || message.bleOpCode == BLEOperationCodeSyncSmokingData ) {
//                [self refreshChartsByCollectionView:[[self.collectionsBackView subviews] lastObject]];
//            }
            
        }
            break;
        case BLENotificationCodeDeviceUnSupported: {
            
        }
            break;
        case BLENotificationCodeNotAddDevice: {
            
        }
            break;
        case BLENotificationCodeConnectDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeInitDeviceTimeOut: {
            
        }
            break;
        case BLENotificationCodeFailToPerformOperation: {
            
        }
            break;
        case BLENotificationCodeDisconnectPeripheral: {
            
        }
            break;
        case BLENotificationCodeFailToConnect: {
            
        }
            break;
    }
    
}

//==========================================================================================================================
#pragma mark - Button事件处理方法
//==========================================================================================================================
/**
 * 按每2小时一个柱状显示吸烟统计图表
 **/
- (IBAction)onHourButton:(UIButton *)sender {
    [self setCurrentTimeSegmentType:SmokingTimeSegmentTypeHour];
    [self refreshChartsByCollectionView:self.hourCollectionView];
}

/**
 * 按每天一个柱状显示吸烟统计图表
 **/
- (IBAction)onDayButton:(UIButton *)sender {
    [self setCurrentTimeSegmentType:SmokingTimeSegmentTypeDay];
    [self refreshChartsByCollectionView:self.dayCollectionView];
}

/**
 * 按每月一个柱状显示吸烟统计图表
 **/
- (IBAction)onMonthButton:(UIButton *)sender {
    [self setCurrentTimeSegmentType:SmokingTimeSegmentTypeMonth];
    [self refreshChartsByCollectionView:self.monthCollectionView];
}

/**
 * 按每年一个柱状显示吸烟统计图表
 **/
- (IBAction)onYearButton:(UIButton *)sender {
    [self setCurrentTimeSegmentType:SmokingTimeSegmentTypeYear];
    [self refreshChartsByCollectionView:self.yearCollectionView];
}



/**
 * 显示吸烟口数统计图表
 **/
- (IBAction)onSmokingPuffsButton:(UIButton *)sender {
    [self showChartByStatisticsType:SmokingStatisticsTypeSmokingPuffs];
    [self refreshChartsByCollectionView:[[self.collectionsBackView subviews] lastObject]];
}

/**
 * 显示吸烟次数统计图表
 **/
- (IBAction)onSmokingTimeButton:(UIButton *)sender {
    [self showChartByStatisticsType:SmokingStatisticsTypeSmokingTime];
    [self refreshChartsByCollectionView:[[self.collectionsBackView subviews] lastObject]];
}


/**
 * 查看吸烟位置
 **/
- (IBAction)onSmokingLocationButton:(UIButton *)sender {
        
    BaseViewController *smokingLocationVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Data, @"SmokingLocationViewController");
    [self.navigationController pushViewController:smokingLocationVC animated:YES];
}

/**
 * 同步
 **/
- (void)onSyncButton:(UIButton *)sender {
    [super onSyncButton: sender];
    if ([UserHelper isLogin]) {
        [Utility showIndicatorHUD:@""];
        [self startUploadSmokingData];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
}

/**
 * 分享
 **/
- (void)onShareButton:(UIButton *)sender {
    [super onShareButton:sender];
    ShareContent *shareContent = [[ShareContent alloc] init];
    shareContent.title = @"智能电子烟";
    shareContent.content = @"";
    shareContent.image = [Utility screenshotByView:[Utility getAppDelegate].window];
    [ShareSDKHelper shareWithShareContent:shareContent andView:sender];
    
}


//==========================================================================================================================
#pragma mark - UICollectionViewDataSource
//==========================================================================================================================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    switch (collectionView.tag) {
        case CollectionViewTagValueHour:
            numberOfItems = [helper hourBarCount];
            break;
        case CollectionViewTagValueDay:
            numberOfItems = [helper dayBarCount];
            break;
        case CollectionViewTagValueMonth:
            numberOfItems = [helper monthBarCount];
            break;
        case CollectionViewTagValueYear:
            numberOfItems = [helper yearBarCount];
            break;
    }
    
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BarChartCell *barChartCell = [collectionView dequeueReusableCellWithReuseIdentifier:BarChartCell_ReuseableIdentifier forIndexPath:indexPath];
    
    barChartCell.delegate       = self;
    barChartCell.collectionView = collectionView;
    barChartCell.pageNumber     = indexPath.item;
    
    switch (collectionView.tag) {
        case CollectionViewTagValueHour: {
            [helper showHourChartByBarChartCell:barChartCell IsSelected:(selectedHourPageIndex == indexPath.item)];
        }
            break;
        case CollectionViewTagValueDay: {
            [helper showDayChartByBarChartCell:barChartCell IsSelected:(selectedDayPageIndex == indexPath.item)];
        }
            break;
        case CollectionViewTagValueMonth: {
            [helper showMonthChartByBarChartCell:barChartCell IsSelected:(selectedMonthPageIndex == indexPath.item)];
        }
            break;
        case CollectionViewTagValueYear: {
            [helper showYearChartByBarChartCell:barChartCell IsSelected:(selectedYearPageIndex == indexPath.item)];
        }
            break;
    }
    
    return barChartCell;
}


//==============================================================
#pragma mark UICollectionViewDelegateFlowLayout
//==============================================================
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kBarWidth_In_CollectionCell, kCollectionCell_height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}


//==========================================================================================================================
#pragma mark - BarChartCellDelegate
//==========================================================================================================================
- (void)barChartCell:(BarChartCell *)barChartCell didTapGesture:(UIGestureRecognizer *)recognizer {
    NSArray *visibleCells = [barChartCell.collectionView visibleCells];
    
    switch (barChartCell.collectionView.tag) {
        case CollectionViewTagValueHour: {
            selectedHourPageIndex = barChartCell.pageNumber;
            for (BarChartCell *cell in visibleCells) {
                if (cell.pageNumber == selectedHourPageIndex) {
                    DebugLog(@"%@", cell.smokingData);
                    [self setSmokingPuffsAndTimeAndStatusBySmokingData:cell.smokingData];
                    break;
                }
            }
            [self.hourCollectionView reloadData];
        }
            break;
        case CollectionViewTagValueDay: {
            selectedDayPageIndex = barChartCell.pageNumber;
            for (BarChartCell *cell in visibleCells) {
                if (cell.pageNumber == selectedDayPageIndex) {
                    DebugLog(@"%@", cell.smokingData);
                    [self setSmokingPuffsAndTimeAndStatusBySmokingData:cell.smokingData];
                    break;
                }
            }
            [self.dayCollectionView reloadData];
        }
            break;
        case CollectionViewTagValueMonth: {
            selectedMonthPageIndex = barChartCell.pageNumber;
            for (BarChartCell *cell in visibleCells) {
                if (cell.pageNumber == selectedMonthPageIndex) {
                    DebugLog(@"%@", cell.smokingData);
                    [self setSmokingPuffsAndTimeAndStatusBySmokingData:cell.smokingData];
                    break;
                }
            }
            [self.monthCollectionView reloadData];
        }
            break;
        case CollectionViewTagValueYear: {
            selectedYearPageIndex = barChartCell.pageNumber;
            for (BarChartCell *cell in visibleCells) {
                if (cell.pageNumber == selectedYearPageIndex) {
                    DebugLog(@"%@", cell.smokingData);
                    [self setSmokingPuffsAndTimeAndStatusBySmokingData:cell.smokingData];
                    break;
                }
            }
            [self.yearCollectionView reloadData];
        }
            break;
    }
    
}



//==========================================================================================================================
#pragma mark - 上传吸烟数据
//==========================================================================================================================
/**
 * 开始上传吸烟数据
 **/
- (void)startUploadSmokingData {
    
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld AND %K<%ld",
                                      kFieldName_UserId, [UserHelper currentUserId],
                                      kFieldName_SyncTag, SyncTagNotSynchronized,
                                      kFieldName_HourIndex, [IDGenerator generateHourIndexByDate:[NSDate date]]];
            NSArray *sSmokings = [DBSmoking MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
            NSMutableArray *smokingDataMsgs         = [NSMutableArray new];
            weakSelf.currentUploadedSmokingDataIds  = [NSMutableArray new];
            for (DBSmoking *sSmoking in sSmokings) {
                SmokingDataMessage *smokingDataMsg = [[SmokingDataMessage alloc] init];
                smokingDataMsg.smokingId       = [sSmoking.smokingId longLongValue];
                smokingDataMsg.userId          = [sSmoking.userId longLongValue];
                
                smokingDataMsg.smokingDt       = [IDGenerator generateTimeStampByDate:sSmoking.smokingDt];
                smokingDataMsg.hourIndex       = [sSmoking.hourIndex intValue];
                smokingDataMsg.dayIndex        = [sSmoking.dayIndex intValue];
                smokingDataMsg.monthIndex      = [sSmoking.monthIndex intValue];
                smokingDataMsg.yearIndex       = [sSmoking.yearIndex intValue];
                smokingDataMsg.numberOfPuffs   = [sSmoking.numberOfPuffs intValue];
                
                smokingDataMsg.workMode        = [sSmoking.workMode intValue];
                smokingDataMsg.powerTemp       = [sSmoking.powerOrTemp intValue];
                smokingDataMsg.smokingTime     = [sSmoking.smokingTime intValue];
                smokingDataMsg.battery         = [sSmoking.battery intValue];
                smokingDataMsg.resistanceValue = [sSmoking.resistanceValue intValue];
                
                smokingDataMsg.longitude       = [sSmoking.longitude doubleValue];
                smokingDataMsg.latitude        = [sSmoking.latitude doubleValue];
                smokingDataMsg.address         = sSmoking.address;
                
                [smokingDataMsgs addObject:smokingDataMsg];
                [weakSelf.currentUploadedSmokingDataIds addObject:sSmoking.smokingId];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadSmokingDataCommand *uploadSmokingDataCommand = [[UploadSmokingDataCommand alloc] initUploadSmokingDataCommandWithSession:[UserHelper currentUserSession] SmokingDataMsgs:smokingDataMsgs];
                [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:uploadSmokingDataCommand];
            });
        });

}


/**
 * 开始上传吸烟位置数据
 **/
- (void)startUploadSmokingLocationData {

        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld AND %K<%ld",
                                      kFieldName_UserId, [UserHelper currentUserId],
                                      kFieldName_SyncTag, SyncTagNotSynchronized,
                                      kFieldName_DayIndex, [IDGenerator generateDayIndexByDate:[NSDate date]]];
            NSArray *sSmokingDetails = [DBSmokingDetail MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
            NSMutableArray *smokingLocationDataMsgs = [NSMutableArray new];
            weakSelf.currentUploadedSmokingLocationDataIds = [NSMutableArray new];
            for (DBSmokingDetail *sSmokingDetail in sSmokingDetails) {
                SmokingLocationDataMessage *smokingLocationDataMsg = [[SmokingLocationDataMessage alloc] init];
                smokingLocationDataMsg.smokingId       = [sSmokingDetail.smokingId longLongValue];
                smokingLocationDataMsg.userId          = [sSmokingDetail.userId longLongValue];
                smokingLocationDataMsg.smokingDt       = [IDGenerator generateTimeStampByDate:sSmokingDetail.smokingDt];;
                
                smokingLocationDataMsg.workMode        = [sSmokingDetail.workMode intValue];
                smokingLocationDataMsg.powerTemp       = [sSmokingDetail.powerOrTemp intValue];
                smokingLocationDataMsg.smokingTime     = [sSmokingDetail.smokingTime intValue];
                smokingLocationDataMsg.battery         = [sSmokingDetail.battery intValue];
                smokingLocationDataMsg.resistanceValue = [sSmokingDetail.resistanceValue intValue];
                
                smokingLocationDataMsg.longitude       = [sSmokingDetail.longitude doubleValue];
                smokingLocationDataMsg.latitude        = [sSmokingDetail.latitude doubleValue];
                smokingLocationDataMsg.address         = sSmokingDetail.address;
                
                [smokingLocationDataMsgs addObject:smokingLocationDataMsg];
                [weakSelf.currentUploadedSmokingLocationDataIds addObject:sSmokingDetail.smokingId];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadSmokingLocationDataCommand *uploadSmokingLocationDataCommand = [[UploadSmokingLocationDataCommand alloc] initUploadSmokingLocationDataCommandWithWithSession:[UserHelper currentUserSession] SmokingLocationDataMsgs:smokingLocationDataMsgs];
                [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:uploadSmokingLocationDataCommand];
            });
        });

}

/**
 * 开始上传心率血氧数据
 **/
- (void)startUploadHeartRateData {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%ld AND %K<%@",
                                  kFieldName_UserId, [UserHelper currentUserId],
                                  kFieldName_SyncTag, SyncTagNotSynchronized,
                                  kFieldName_HeartRateDt, [NSDate dateStartOfDay:[NSDate date]]];
        NSArray *sHeartRates = [DBHeartRate MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
        NSMutableArray *heartRateDataMsgs = [NSMutableArray new];
        weakSelf.currentUploadedHeartRateDataIds = [NSMutableArray new];
        for (DBHeartRate *sHeartRate in sHeartRates) {
            HeartRateDataMessage *heartRateRateMsg = [HeartRateDataMessage new];
            heartRateRateMsg.heartRateId    = [sHeartRate.heartRateId longLongValue];
            heartRateRateMsg.userId         = [sHeartRate.userId longLongValue];
            heartRateRateMsg.heartRateDt    = [IDGenerator generateTimeStampByDate:sHeartRate.heartRateDt];
            heartRateRateMsg.heartRate      = [sHeartRate.heartRate integerValue];
            heartRateRateMsg.bloodOxygen    = [sHeartRate.bloodOxygen integerValue];
            
            [heartRateDataMsgs addObject:heartRateRateMsg];
            [weakSelf.currentUploadedHeartRateDataIds addObject:sHeartRate.heartRateId];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UploadHeartRateDataCommand *uploadHeartRateDataCommand = [[UploadHeartRateDataCommand alloc] initUploadHeartRateDataCommandWithSession:[UserHelper currentUserSession] HeartRateDataMsgs:heartRateDataMsgs];
            [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:uploadHeartRateDataCommand];
        });
    });
    
}

//==========================================================================================================================
#pragma mark - TcpCommandHelperDelegate
//==========================================================================================================================
-(void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    [super didCommandSuccessWithResult:result andOpCode:opCode];
    NSError *error;
    switch (opCode) {
        case OperationCodeUploadSmokingData: {
            UploadSmokingDataResponseMessage *uploadSmokingDataResponseMsg = [UploadSmokingDataResponseMessage parseFromData:result error:&error];
            if (error == nil && uploadSmokingDataResponseMsg != nil && uploadSmokingDataResponseMsg.errorMsg.errorCode == 0) {
                
                //======================================================
                //处理上传吸烟数据时从服务端返回的结果
                //======================================================
                NSMutableArray *successIds = [NSMutableArray new];
                if (uploadSmokingDataResponseMsg.failCount == 0) {
                    successIds = self.currentUploadedSmokingDataIds;
                }
                else {
                    for (NSNumber *smokingId in self.currentUploadedSmokingDataIds) {
                        BOOL isExists = NO;
                        for (UploadFailDataMessage *uploadFailDataMsg in uploadSmokingDataResponseMsg.failListArray) {
                            if ([smokingId longLongValue] == uploadFailDataMsg.failId) {
                                isExists = YES;
                                break;
                            }
                        }
                        if (!isExists) {
                            [successIds addObject:smokingId];
                        }
                    }
                }
                
                __weak typeof(self) weakSelf = self;
                [MagicalRecord  saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    for (NSNumber *smokingId in successIds) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%lld", kFieldName_SmokingId, [smokingId longLongValue], kFieldName_UserId, [UserHelper currentUserId]];
                        DBSmoking *sSmoking = [DBSmoking MR_findFirstWithPredicate:predicate inContext:localContext];
                        if (sSmoking != nil) {
                            sSmoking.syncTag = @(SyncTagSynchronized);
                        }
                    }
                } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    [weakSelf startUploadSmokingLocationData];
                }];
            }
            else {
                [Utility hideIndicatorHUD];
                [self showErrorMessage:(uploadSmokingDataResponseMsg!=nil?uploadSmokingDataResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keySynchronousDataFailed))];//@"同步吸烟数据失败"
                if (error ==nil && uploadSmokingDataResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
            break;
        case OperationCodeUploadSmokingLocationData: {
            UploadSmokingLocationDataResponseMessage *uploadSmokingLocationDataResponseMsg = [UploadSmokingLocationDataResponseMessage parseFromData:result error:&error];
            if (error == nil && uploadSmokingLocationDataResponseMsg != nil && uploadSmokingLocationDataResponseMsg.errorMsg.errorCode == 0) {
                
                //======================================================
                //处理上传吸烟位置数据时从服务端返回的结果
                //======================================================
                NSMutableArray *successIds = [NSMutableArray new];
                if (uploadSmokingLocationDataResponseMsg.failCount == 0) {
                    successIds = self.currentUploadedSmokingLocationDataIds;
                }
                else {
                    for (NSNumber *smokingId in self.currentUploadedSmokingLocationDataIds) {
                        BOOL isExists = NO;
                        for (UploadFailDataMessage *uploadFailDataMsg in uploadSmokingLocationDataResponseMsg.failListArray) {
                            if ([smokingId longLongValue] == uploadFailDataMsg.failId) {
                                isExists = YES;
                                break;
                            }
                        }
                        if (!isExists) {
                            [successIds addObject:smokingId];
                        }
                    }
                }
                
                __weak typeof(self) weakSelf = self;
                [MagicalRecord  saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    for (NSNumber *smokingId in successIds) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%lld", kFieldName_SmokingId, [smokingId longLongValue], kFieldName_UserId, [UserHelper currentUserId]];
                        DBSmokingDetail *sSmokingDetail = [DBSmokingDetail MR_findFirstWithPredicate:predicate inContext:localContext];
                        if (sSmokingDetail != nil) {
                            sSmokingDetail.syncTag = @(SyncTagSynchronized);
                        }
                    }
                        
                } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    [weakSelf startUploadHeartRateData];
                }];
            }
            else {
                [Utility hideIndicatorHUD];
                [self showErrorMessage:(uploadSmokingLocationDataResponseMsg!=nil?uploadSmokingLocationDataResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keySynchronousDataSuccessfully))];//@"同步吸烟数据失败"
                if (error ==nil && uploadSmokingLocationDataResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
            break;
        case OperationCodeUploadHeartRateData: {
            UploadHeartRateDataResponseMessage *uploadHeartRateDataResponseMsg = [UploadHeartRateDataResponseMessage parseFromData:result error:&error];
            if (error == nil && uploadHeartRateDataResponseMsg != nil && uploadHeartRateDataResponseMsg.errorMsg.errorCode == 0) {
                
                //======================================================
                //处理上传心率血氧数据时从服务端返回的结果
                //======================================================
                NSMutableArray *successIds = [NSMutableArray new];
                if (uploadHeartRateDataResponseMsg.failCount == 0) {
                    successIds = self.currentUploadedHeartRateDataIds;
                }
                else {
                    for (NSNumber *heartRateId in self.currentUploadedHeartRateDataIds) {
                        BOOL isExists = NO;
                        for (UploadFailDataMessage *uploadFailDataMsg in uploadHeartRateDataResponseMsg.failListArray) {
                            if ([heartRateId longLongValue] == uploadFailDataMsg.failId) {
                                isExists = YES;
                                break;
                            }
                        }
                        if (!isExists) {
                            [successIds addObject:heartRateId];
                        }
                    }
                }
                
                __weak typeof(self) weakSelf = self;
                [MagicalRecord  saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    for (NSNumber *heartRateId in successIds) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%lld AND %K==%lld", kFieldName_HeartRateId, [heartRateId longLongValue], kFieldName_UserId, [UserHelper currentUserId]];
                        DBHeartRate *sHeartRate = [DBHeartRate MR_findFirstWithPredicate:predicate inContext:localContext];
                        if (sHeartRate != nil) {
                            sHeartRate.syncTag = @(SyncTagSynchronized);
                        }
                    }
                    
                } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    [Utility hideIndicatorHUD];
                    [weakSelf showSuccessMessage:LOCALIZED_STRING(keySynchronousDataSuccessfully)];//@"同步数据成功"
                }];
            }
            else {
                [Utility hideIndicatorHUD];
                [self showErrorMessage:(uploadHeartRateDataResponseMsg!=nil?uploadHeartRateDataResponseMsg.errorMsg.errorMsg:LOCALIZED_STRING(keySynchronousDataSuccessfully))];//@"同步吸烟数据失败"
                if (error ==nil && uploadHeartRateDataResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
            break;
    }

}

-(void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
}










@end
