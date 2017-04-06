//
//  HeartRateHistoryViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "HeartRateHistoryViewController.h"
#import "PMCalendar.h"
#import "HeartRateHistoryListItemCell.h"

static NSString *const kCellIdentifier_HeartRateHistoryListItemCell     = @"HeartRateHistoryListItemCell";

@interface HeartRateHistoryViewController () <UITableViewDataSource, UITableViewDelegate, PMCalendarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView             *positionView;
@property (weak, nonatomic) IBOutlet UITableView        *layoutTablView;
@property (weak, nonatomic) IBOutlet UILabel            *noDataLabel;

@property (strong, nonatomic) PMCalendarController      *calendarVC;

@property (strong, nonatomic) NSDate                    *showedDate;
@property (strong, nonatomic) NSMutableArray            *heartRates;

@end

@implementation HeartRateHistoryViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = LOCALIZED_STRING(keyToday);//@"今天";
    [self setNavigationBarTitle:LOCALIZED_STRING(keyToday)];
    [self setupCalendarButtonInRightBarButtonItem];
    [self setupShareButtonInRightBarButtonItem];
    
    self.showedDate = [NSDate date];
    self.heartRates = [NSMutableArray new];
    
    [self showHeartRateHistoryByDate:self.showedDate];
    
//    for (int i=0; i<5; i++) {
//        HeartRate *heartRate = [[HeartRate alloc] init];
//        heartRate.heartRateDt = [NSDate date];
//        heartRate.heartRate  = 80;
//        heartRate.bloodOxygen = 97;
//        [self.heartRates addObject:heartRate];
//    }
//    
//    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 在NavigationBar右边添加日历按钮
 **/
- (void)setupCalendarButtonInRightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar22"] style:UIBarButtonItemStylePlain target:self action:@selector(onCalendarButton:)] animated:NO];
}

/**
 * 设置导航栏标题
 **/
- (void)setNavigationBarTitle:(NSString *)navigationBarTitle {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    UIImageView *iconImgView = [UIImageView new];
//    [iconImgView setImage:[UIImage imageNamed:@"calendar22"]];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:navigationBarTitle];
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton addTarget:self action:@selector(onCalendarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubviews:@[iconImgView, titleLabel, calendarButton]];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.equalTo(titleView);
        make.trailing.equalTo(titleLabel.mas_leading).offset(-4);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
//        make.centerX.equalTo(titleView).offset(13.f);
        make.centerX.equalTo(titleView);
    }];
    
    [calendarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(titleView);
    }];
    
    self.navigationItem.titleView = titleView;
}


///**
// * 在NavigationBar右边添加分享按钮
// **/
//- (void)setupLeftShareButtonInLeftBarButtonItem {
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share22"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftShareButton:)] animated:NO];
//}

/**
 * 显示指定日期的心率检测历史
 **/
- (void)showHeartRateHistoryByDate:(NSDate *)date {
    NSArray *heartRates = [HeartRateDataAccessor findHeartRatesByDate:date];
    self.heartRates = [NSMutableArray arrayWithArray:heartRates];
    [self.layoutTablView reloadData];
    [self.noDataLabel setHidden:(self.heartRates.count!=0)];
}

//=====================================================================================
#pragma mark - UIbutton事件处理方法
//=====================================================================================
/**
 * 点击日历按钮的事件处理方法
 **/
- (void)onCalendarButton:(UIButton *)sender {
    if ([self.calendarVC isCalendarVisible]) {
        [self.calendarVC dismissCalendarAnimated:YES];
        return;
    }
    CGSize calendarSize = CGSizeMake(kScreen_Width, 300);
    switch (kiPhone_Version) {
        case kiPhone_5_5:
            calendarSize = CGSizeMake(kScreen_Width, 400);
            break;
        case kiPhone_4_7:
            calendarSize = CGSizeMake(kScreen_Width, 380);
            break;
    }
    self.calendarVC = [[PMCalendarController alloc] initWithThemeName:@"Smoking" andSize:calendarSize];
    self.calendarVC.allowsPeriodSelection = NO;
    self.calendarVC.delegate = self;
    [self.calendarVC presentCalendarFromView:self.positionView
                    permittedArrowDirections:PMCalendarArrowDirectionDown
                                   isPopover:YES
                                    animated:YES];
    
    //注意，该调用必须在presentCalendarFromView后面，否则会出现控件中的日期显示不全的问题
    self.calendarVC.period = [PMPeriod oneDayPeriodWithDate:self.showedDate];
    //    [self calendarController:calendarVC didChangePeriod:calendarVC.period];
}

/**
 * 分享按钮点击事件的处理方法
 **/
- (void)onShareButton:(UIButton *)sender {
    [super onShareButton:sender];
    ShareContent *shareContent = [[ShareContent alloc] init];
    shareContent.title = @"智能电子烟";
    shareContent.content = @"";
    shareContent.image = [Utility screenshotByView:[Utility getAppDelegate].window];
    [ShareSDKHelper shareWithShareContent:shareContent andView:sender];
}


//=========================================================
#pragma mark - PMCalendarControllerDelegate
//=========================================================
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod {
    
    if (newPeriod.isUserSelected) {
        self.showedDate = newPeriod.startDate;
        NSInteger showedDayIndex = [IDGenerator generateDayIndexByDate:self.showedDate];
        if (showedDayIndex == [IDGenerator generateDayIndexByDate:[NSDate date]]) {
            [self setNavigationBarTitle:LOCALIZED_STRING(keyToday)];
        }
        else {
            [self setNavigationBarTitle:[self.showedDate string_yyyy_MM_dd]];
        }
        [self showHeartRateHistoryByDate:self.showedDate];
    }
    
}


//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.heartRates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.heartRates.count - 1) {
        return 8;
    }
    else {
        return 7;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeartRateHistoryListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_HeartRateHistoryListItemCell forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    [cell setHeartRate:self.heartRates[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
