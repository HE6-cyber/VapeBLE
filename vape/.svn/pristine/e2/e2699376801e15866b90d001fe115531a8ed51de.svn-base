//
//  BarChartCell.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SmokingStatistics;
@protocol BarChartCellDelegate;

//=======================自定义常量、宏===========================
#define kCollectionCell_height          (kContentInNavAndTab_Height - 200 - 35 + 20)
#define kBarWidth_In_CollectionCell     (kScreen_Width*0.2)
//==============================================================

extern NSString *const BarChartCell_ReuseableIdentifier;

@interface BarChartCell : UICollectionViewCell

@property (weak,   nonatomic) id<BarChartCellDelegate>  delegate;
@property (assign, nonatomic) NSInteger                 pageNumber; //页码，从0开始
@property (weak,   nonatomic) UICollectionView          *collectionView;
@property (strong, nonatomic) SmokingStatistics         *smokingData;

@property (assign, nonatomic) BOOL                      isAllowSelect;
@property (assign, nonatomic) BOOL                      isSelected;
@property (assign, nonatomic) BOOL                      isShowYAxisValue;
@property (assign, nonatomic) BOOL                      isShowTitle;

@property (assign, nonatomic) NSInteger yAxisValue;
@property (assign, nonatomic) NSInteger yAxisMaxValue;
@property (strong, nonatomic) NSString  *titleValue;
@property (strong, nonatomic) NSString  *xAixsTitleValue;

/** 刷新整个单元格内容 */
- (void)refresh;

/** 选中或取消选中 */
- (void)selectedBarChartCell:(BOOL)isSelected;

@end

@protocol BarChartCellDelegate <NSObject>

- (void)barChartCell:(BarChartCell *)barChartCell didTapGesture:(UIGestureRecognizer *)recognizer;

@end
