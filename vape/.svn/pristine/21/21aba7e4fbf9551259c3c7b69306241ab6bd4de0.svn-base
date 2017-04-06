//
//  DataViewControllerHelper.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "DataViewControllerHelper.h"
#import "Utility.h"

//============================================================================
const NSInteger  kNumber_Of_Bars_In_HourChartView   = 12;
const NSInteger  kNumber_Of_Bars_In_OtherChartView  = 5;
//============================================================================

@interface DataViewControllerHelper () {
    
}

@property (strong, nonatomic) NSDate    *minimumSmokingDt;  //最早的吸烟时间，因该数据不会变化，故只需要取一次即可
@property (strong, nonatomic) NSDate    *maximumSmokingDt;  //最晚的吸烟时间（刷新图表时，需要首先更新该值，然后查询图表数据并显示）

@property (strong, nonatomic) Smoking   *maxHourSmoking;
@property (strong, nonatomic) Smoking   *maxDaySmoking;
@property (strong, nonatomic) Smoking   *maxMonthSmoking;
@property (strong, nonatomic) Smoking   *maxYearSmoking;

@end

@implementation DataViewControllerHelper

//==========================================================================================================================
#pragma mark - 初始化方法
//==========================================================================================================================
- (instancetype)init {
    if ([super init]) {
        self.timeSegmentType    = SmokingTimeSegmentTypeHour;
        self.statisticsType     = SmokingStatisticsTypeSmokingPuffs;
        [self refreshDataSource];
    }
    return self;
}



//==========================================================================================================================
#pragma mark -
//==========================================================================================================================
/**
 * 刷新数据源，使图表能够从数据库中获取最新的数据
 **/
- (void)refreshDataSource {
    self.minimumSmokingDt   = [SmokingDataAccessor getMinimumSmokingDtByUserId:[UserHelper currentUserId]];
    self.maximumSmokingDt   = [NSDate date];
    self.maxHourSmoking     = [SmokingDataAccessor getMaxHourSmokingDataByUserId:[UserHelper currentUserId]];
    self.maxDaySmoking      = [SmokingDataAccessor getMaxDaySmokingDataByUserId:[UserHelper currentUserId]];
    self.maxMonthSmoking    = [SmokingDataAccessor getMaxMonthSmokingDataByUserId:[UserHelper currentUserId]];
    self.maxYearSmoking     = [SmokingDataAccessor getMaxYearSmokingDataByUserId:[UserHelper currentUserId]];
}

- (void)refreshHourDataSource {
    self.minimumSmokingDt   = [SmokingDataAccessor getMinimumSmokingDtByUserId:[UserHelper currentUserId]];
    self.maximumSmokingDt   = [NSDate date];
    self.maxHourSmoking     = [SmokingDataAccessor getMaxHourSmokingDataByUserId:[UserHelper currentUserId]];
}

- (void)refreshDayDataSource {
    self.minimumSmokingDt   = [SmokingDataAccessor getMinimumSmokingDtByUserId:[UserHelper currentUserId]];
    self.maximumSmokingDt   = [NSDate date];
    self.maxDaySmoking      = [SmokingDataAccessor getMaxDaySmokingDataByUserId:[UserHelper currentUserId]];
}

- (void)refreshMonthDataSource {
    self.minimumSmokingDt   = [SmokingDataAccessor getMinimumSmokingDtByUserId:[UserHelper currentUserId]];
    self.maximumSmokingDt   = [NSDate date];
    self.maxMonthSmoking    = [SmokingDataAccessor getMaxMonthSmokingDataByUserId:[UserHelper currentUserId]];
}

- (void)refreshYearDataSource {
    self.minimumSmokingDt   = [SmokingDataAccessor getMinimumSmokingDtByUserId:[UserHelper currentUserId]];
    self.maximumSmokingDt   = [NSDate date];
    self.maxYearSmoking     = [SmokingDataAccessor getMaxYearSmokingDataByUserId:[UserHelper currentUserId]];
}


//==========================================================================================================================
#pragma mark - 计算图表Bar的总数量
//==========================================================================================================================
/**
 * 年图表中Bar的总数量
 **/
- (NSInteger)yearBarCount {
     return [self actualYearBarCount] < kNumber_Of_Bars_In_OtherChartView ? kNumber_Of_Bars_In_OtherChartView : [self actualYearBarCount];
}

/**
 * 月图表中Bar的总数量
 **/
- (NSInteger)monthBarCount {
    return [self actualMonthBarCount] < kNumber_Of_Bars_In_OtherChartView ? kNumber_Of_Bars_In_OtherChartView : [self actualMonthBarCount];
}

/**
 * 日图表中Bar的总数量 (<5时，返回5)
 **/
- (NSInteger)dayBarCount {
    return [self actualDayBarCount] < kNumber_Of_Bars_In_OtherChartView ? kNumber_Of_Bars_In_OtherChartView : [self actualDayBarCount];
}

/**
 * 时图表中Bar的总数量 (<5时，返回5)
 **/
- (NSInteger)hourBarCount {
    return [self actualHourBarCount] < kNumber_Of_Bars_In_OtherChartView ? kNumber_Of_Bars_In_OtherChartView : [self actualHourBarCount];;
}



/**
 * 年图表的实际的Bar个数（不算填充用的Bar）
 **/
- (NSInteger)actualYearBarCount {
    return [[NSDate sharedCalendar] components:NSCalendarUnitYear
                                      fromDate:[NSDate dateStartOfYear:self.minimumSmokingDt]
                                        toDate:[NSDate dateEndOfYear:self.maximumSmokingDt] options:0].year + 1;
}

/**
 * 月图表的实际的Bar个数（不算填充用的Bar）
 **/
- (NSInteger)actualMonthBarCount {
    return [[NSDate sharedCalendar] components:NSCalendarUnitMonth
                                      fromDate:[NSDate dateStartOfMonth:self.minimumSmokingDt]
                                        toDate:[NSDate dateEndOfMonth:self.maximumSmokingDt] options:0].month + 1;
}

/**
 * 日图表的实际的Bar个数（不算填充用的Bar）
 **/
- (NSInteger)actualDayBarCount {
    return [[NSDate sharedCalendar] components:NSCalendarUnitDay
                                      fromDate:[NSDate dateStartOfDay:self.minimumSmokingDt]
                                        toDate:[NSDate dateEndOfDay:self.maximumSmokingDt] options:0].day;
}

/**
 * 时图表的实际的Bar个数（不算填充用的Bar）
 **/
- (NSInteger)actualHourBarCount {
    return [self actualDayBarCount] * 12 -  [self.minimumSmokingDt hour]/2 - (23 - [self.maximumSmokingDt hour])/2;
    
}

//==========================================================================================================================
#pragma mark - 获取指定页的数据
//==========================================================================================================================
- (SmokingStatistics *)getHourSmokingDataByPageIndex:(NSInteger)pageIndex {
    NSDate *showedHour                  = [self.minimumSmokingDt offsetHours:pageIndex*2];
    NSInteger showedHourIndex           = [IDGenerator generateHourIndexByDate:showedHour];
    SmokingStatistics *dbReturnValue    = [SmokingDataAccessor selectHourStatisticsByHourIndex:showedHourIndex UserId:[UserHelper currentUserId]];
    return dbReturnValue;
}

- (SmokingStatistics *)getDaySmokingDataByPageIndex:(NSInteger)pageIndex {
    NSDate *showedDay                   = [self.minimumSmokingDt offsetDay:pageIndex];
    NSInteger showedDayIndex            = [IDGenerator generateDayIndexByDate:showedDay];
    SmokingStatistics *dbReturnValue    = [SmokingDataAccessor selectDayStatisticsByDayIndex:showedDayIndex UserId:[UserHelper currentUserId]];
    return dbReturnValue;
}


- (SmokingStatistics *)getMonthSmokingDataByPageIndex:(NSInteger)pageIndex {
    NSDate *showedMonth                 = [self.minimumSmokingDt offsetMonth:pageIndex];
    NSInteger showedMonthIndex          = [IDGenerator generateMonthIndexByDate:showedMonth];
    SmokingStatistics *dbReturnValue    = [SmokingDataAccessor selectMonthStatisticsByMonthIndex:showedMonthIndex UserId:[UserHelper currentUserId]];
    return dbReturnValue;
}


- (SmokingStatistics *)getYearSmokingDataByPageIndex:(NSInteger)pageIndex {
    NSDate *showedYear                  = [self.minimumSmokingDt offsetYear:pageIndex];
    NSInteger showedYearIndex           = [IDGenerator generateYearIndexByDate:showedYear];
    SmokingStatistics *dbReturnValue    = [SmokingDataAccessor selectYearStatisticsByYearIndex:showedYearIndex UserId:[UserHelper currentUserId]];

    return dbReturnValue;
}




//==========================================================================================================================
#pragma mark - 显示图表
//==========================================================================================================================
/**
 * 使用时图表显示数据
 **/
- (BarChartCell *)showHourChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected {
    
    NSDate *showedHour          = [self.minimumSmokingDt offsetHours:barChartCell.pageNumber*2];
    NSInteger showedHourIndex   = [IDGenerator generateHourIndexByDate:showedHour];
    SmokingStatistics *dbReturnValue = [SmokingDataAccessor selectHourStatisticsByHourIndex:showedHourIndex UserId:[UserHelper currentUserId]];
    
    if (barChartCell.pageNumber < [self actualHourBarCount]) {
        if (dbReturnValue == nil) {
            dbReturnValue = [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeHour Index:showedHourIndex SmokingTime:0 NumberOfPuffs:0 UserId:[UserHelper currentUserId]];
        }
        barChartCell.smokingData        = dbReturnValue;
        barChartCell.isAllowSelect      = YES;
        barChartCell.isShowYAxisValue   = YES;
    }
    else {
        barChartCell.isAllowSelect      = NO;
        barChartCell.isShowYAxisValue   = NO;
    }
    
    NSInteger hour = [showedHour hour];
    hour = (hour%2 == 0 ? hour : hour - hour%2);
    
    switch (self.statisticsType) {
        case SmokingStatisticsTypeSmokingPuffs: {
            barChartCell.yAxisMaxValue  = self.maxHourSmoking.numberOfPuffs;
            barChartCell.yAxisValue     = dbReturnValue.numberOfPuffs;
        }
            break;
        case SmokingStatisticsTypeSmokingTime: {
            barChartCell.yAxisMaxValue  = self.maxHourSmoking.smokingTime;
            barChartCell.yAxisValue     = dbReturnValue.smokingTime;
        }
            break;
    }
    barChartCell.isSelected         = isSelected;
    barChartCell.isShowTitle        = YES;
    barChartCell.titleValue         = [NSString stringWithFormat:@"%@", [showedHour stringWithFormat:@"yyyy/MM/dd"]];
    barChartCell.xAixsTitleValue    = [NSString stringWithFormat:@"%ld:00-%ld:59", (long)hour, (long)(hour+1)];
    
    [barChartCell refresh];
    
    return barChartCell;
}


/**
 * 使用日图表显示数据
 **/
- (BarChartCell *)showDayChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected {
    
    NSDate *showedDay           = [self.minimumSmokingDt offsetDay:barChartCell.pageNumber];
    NSInteger showedDayIndex    = [IDGenerator generateDayIndexByDate:showedDay];
    SmokingStatistics *dbReturnValue = [SmokingDataAccessor selectDayStatisticsByDayIndex:showedDayIndex UserId:[UserHelper currentUserId]];
    
    if (barChartCell.pageNumber < [self actualDayBarCount]) {
        if (dbReturnValue == nil) {
            dbReturnValue = [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeDay Index:showedDayIndex SmokingTime:0 NumberOfPuffs:0 UserId:[UserHelper currentUserId]];
        }
        barChartCell.smokingData        = dbReturnValue;
        barChartCell.isAllowSelect      = YES;
        barChartCell.isShowYAxisValue   = YES;
    }
    else {
        barChartCell.isAllowSelect      = NO;
        barChartCell.isShowYAxisValue   = NO;
    }
    
    switch (self.statisticsType) {
        case SmokingStatisticsTypeSmokingPuffs: {
            barChartCell.yAxisMaxValue  = self.maxDaySmoking.numberOfPuffs;
            barChartCell.yAxisValue     = dbReturnValue.numberOfPuffs;
        }
            break;
        case SmokingStatisticsTypeSmokingTime: {
            barChartCell.yAxisMaxValue  = self.maxDaySmoking.smokingTime;
            barChartCell.yAxisValue     = dbReturnValue.smokingTime;
        }
            break;
    }
    barChartCell.isSelected         = isSelected;
    barChartCell.isShowTitle        = NO;
    barChartCell.xAixsTitleValue    = [NSString stringWithFormat:@"%@", [showedDay string_yyyy_MM_dd]];
    
    [barChartCell refresh];
    
    return barChartCell;
}


/**
 * 使用月图表显示数据
 **/
- (BarChartCell *)showMonthChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected {
    
    NSDate *showedMonth         = [self.minimumSmokingDt offsetMonth:barChartCell.pageNumber];
    NSInteger showedMonthIndex  = [IDGenerator generateMonthIndexByDate:showedMonth];
    SmokingStatistics *dbReturnValue = [SmokingDataAccessor selectMonthStatisticsByMonthIndex:showedMonthIndex UserId:[UserHelper currentUserId]];
    
    if (barChartCell.pageNumber < [self actualMonthBarCount]) {
        if (dbReturnValue == nil) {
            dbReturnValue = [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeMonth Index:showedMonthIndex SmokingTime:0 NumberOfPuffs:0 UserId:[UserHelper currentUserId]];
        }

        barChartCell.smokingData        = dbReturnValue;
        barChartCell.isAllowSelect      = YES;
        barChartCell.isShowYAxisValue   = YES;
    }
    else {
        barChartCell.isAllowSelect      = NO;
        barChartCell.isShowYAxisValue   = NO;
    }
    
    switch (self.statisticsType) {
        case SmokingStatisticsTypeSmokingPuffs: {
            barChartCell.yAxisMaxValue  = self.maxMonthSmoking.numberOfPuffs;
            barChartCell.yAxisValue     = dbReturnValue.numberOfPuffs;
        }
            break;
        case SmokingStatisticsTypeSmokingTime: {
            barChartCell.yAxisMaxValue  = self.maxMonthSmoking.smokingTime;
            barChartCell.yAxisValue     = dbReturnValue.smokingTime;
        }
            break;
    }
    barChartCell.isSelected         = isSelected;
    barChartCell.isShowTitle        = NO;
    barChartCell.xAixsTitleValue    = [NSString stringWithFormat:@"%@", [showedMonth string_yyyy_MM]];
    
    [barChartCell refresh];
    
    return barChartCell;
}


/**
 * 使用年图表显示数据
 **/
- (BarChartCell *)showYearChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected {
    
    NSDate *showedYear          = [self.minimumSmokingDt offsetYear:barChartCell.pageNumber];
    NSInteger showedYearIndex   = [IDGenerator generateYearIndexByDate:showedYear];
    SmokingStatistics *dbReturnValue = [SmokingDataAccessor selectYearStatisticsByYearIndex:showedYearIndex UserId:[UserHelper currentUserId]];
    
    if (barChartCell.pageNumber < [self actualYearBarCount]) {
        if (dbReturnValue == nil) {
            dbReturnValue = [[SmokingStatistics alloc] initWithIndexType:SmokingDataIndexTypeYear Index:showedYearIndex SmokingTime:0 NumberOfPuffs:0 UserId:[UserHelper currentUserId]];
        }
  
        barChartCell.smokingData        = dbReturnValue;
        barChartCell.isAllowSelect      = YES;
        barChartCell.isShowYAxisValue   = YES;
    }
    else {
        barChartCell.isAllowSelect      = NO;
        barChartCell.isShowYAxisValue   = NO;
    }
    
    switch (self.statisticsType) {
        case SmokingStatisticsTypeSmokingPuffs: {
            barChartCell.yAxisMaxValue  = self.maxYearSmoking.numberOfPuffs;
            barChartCell.yAxisValue     = dbReturnValue.numberOfPuffs;
        }
            break;
        case SmokingStatisticsTypeSmokingTime: {
            barChartCell.yAxisMaxValue  = self.maxYearSmoking.smokingTime;
            barChartCell.yAxisValue     = dbReturnValue.smokingTime;
        }
            break;
    }
    barChartCell.isSelected         = isSelected;
    barChartCell.isShowTitle        = NO;
    barChartCell.xAixsTitleValue    = [NSString stringWithFormat:@"%@", [showedYear string_yyyy]];
    
    [barChartCell refresh];
    
    return barChartCell;
}









@end
