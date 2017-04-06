//
//  DataViewControllerHelper.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarChartCell.h"
#import "SmokingDataAccessor.h"

//============================================================================
extern const NSInteger  kNumber_Of_Bars_In_HourChartView;
extern const NSInteger  kNumber_Of_Bars_In_OtherChartView;
//============================================================================


//============================================================================
#pragma mark - 辅助用的枚举
//============================================================================
/**
 *  时间段类型
 **/
typedef NS_ENUM(NSInteger, SmokingTimeSegmentType) {
    SmokingTimeSegmentTypeHour      = 0,
    SmokingTimeSegmentTypeDay       = 1,
    SmokingTimeSegmentTypeMonth     = 2,
    SmokingTimeSegmentTypeYear      = 3
};

/**
 *  吸烟统计类型
 **/
typedef NS_ENUM(NSInteger, SmokingStatisticsType) {
    SmokingStatisticsTypeSmokingPuffs,      //吸烟口数
    SmokingStatisticsTypeSmokingTime        //吸烟时长
};








@interface DataViewControllerHelper : NSObject

@property (assign, nonatomic) SmokingTimeSegmentType    timeSegmentType;
@property (assign, nonatomic) SmokingStatisticsType     statisticsType;

- (instancetype)init;

//============================================================================
#pragma mark -
//============================================================================
/**
 * 刷新数据源，使图表能够从数据库中获取最新的数据
 **/
- (void)refreshDataSource;

- (void)refreshHourDataSource;
- (void)refreshDayDataSource;
- (void)refreshMonthDataSource;
- (void)refreshYearDataSource;


//==========================================================================================================================
#pragma mark - 计算图表的页数、Bar的总数量
//==========================================================================================================================
/** 年图表中Bar的总数量 */
- (NSInteger)yearBarCount;
/** 月图表中Bar的总数量 */
- (NSInteger)monthBarCount;
/** 日图表中Bar的总数量 */
- (NSInteger)dayBarCount;
/** 时图表中Bar的总数量 */
- (NSInteger)hourBarCount;


/** 年图表的实际的Bar个数（不算填充用的Bar）*/
- (NSInteger)actualYearBarCount;
/** 月图表的实际的Bar个数（不算填充用的Bar）*/
- (NSInteger)actualMonthBarCount;
/** 日图表的实际的Bar个数（不算填充用的Bar）*/
- (NSInteger)actualDayBarCount;
/** 时图表的实际的Bar个数（不算填充用的Bar）*/
- (NSInteger)actualHourBarCount;

//==========================================================================================================================
#pragma mark - 获取指定页的数据
//==========================================================================================================================
- (SmokingStatistics *)getHourSmokingDataByPageIndex:(NSInteger)pageIndex;
- (SmokingStatistics *)getDaySmokingDataByPageIndex:(NSInteger)pageIndex;
- (SmokingStatistics *)getMonthSmokingDataByPageIndex:(NSInteger)pageIndex;
- (SmokingStatistics *)getYearSmokingDataByPageIndex:(NSInteger)pageIndex;


//==========================================================================================================================
#pragma mark - 显示图表
//==========================================================================================================================
/** 使用时图表显示数据 */
- (BarChartCell *)showHourChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected;
/** 使用日图表显示数据 */
- (BarChartCell *)showDayChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected;
/** 使用月图表显示数据 */
- (BarChartCell *)showMonthChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected;
/** 使用年图表显示数据 */
- (BarChartCell *)showYearChartByBarChartCell:(BarChartCell *)barChartCell IsSelected:(BOOL)isSelected;



@end



