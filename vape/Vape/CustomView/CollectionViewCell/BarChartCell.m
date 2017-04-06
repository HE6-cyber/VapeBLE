//
//  BarChartCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BarChartCell.h"
#import "Utility.h"

#define kBar_Normal_Color                     [UIColor colorWithHexString:@"0xB9E986"]   //Bar的正常颜色
#define kBar_Selected_Color                   [UIColor colorWithHexString:@"0x4DA52F"]   //Bar的选中颜色颜色

NSString *const BarChartCell_ReuseableIdentifier = @"BarChartCell";

@interface BarChartCell ()

@property (weak, nonatomic) IBOutlet UILabel *xAixsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIView *tapGestureView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewHeightConstraint;

@end

@implementation BarChartCell

//=====================================================================
#pragma mark - 初始化方法
//=====================================================================
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.centerLineHeightConstraint.constant = 0.5f;
    self.barViewHeightConstraint.constant = 0.f;
    [self.barView setBackgroundColor:kBar_Normal_Color];
    [self.tapGestureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureInBarChartCell:)]];
}

/**
 * 处理手势
 **/
- (void)handleTapGestureInBarChartCell:(UIGestureRecognizer *)recognizer {
    if (self.isAllowSelect && self.delegate!=nil && [self.delegate respondsToSelector:@selector(barChartCell:didTapGesture:)]) {
        [self.delegate barChartCell:self didTapGesture:recognizer];
    }
    
}


//=====================================================================
#pragma mark - 辅助方法
//=====================================================================
/**
 * 刷新整个单元格内容
 **/
- (void)refresh {
    double multiple = (self.yAxisMaxValue == 0 ? 0 : (double)self.yAxisValue/(double)self.yAxisMaxValue);
    multiple = (multiple > 1 ? 1 : multiple);
    self.barViewHeightConstraint.constant = (kCollectionCell_height-15-19) * multiple;
    
    [self.valueLabel        setHidden:!self.isShowYAxisValue];
    [self.titleLabel        setHidden:!self.isShowTitle];
    [self.valueLabel        setText:[NSString stringWithFormat:@"%ld", (long)self.yAxisValue]];
    [self.titleLabel        setText:self.titleValue];
    [self.xAixsTitleLabel   setText:self.xAixsTitleValue];
    [self selectedBarChartCell:self.isSelected];
}

/**
 * 选中或取消选中
 **/
- (void)selectedBarChartCell:(BOOL)isSelected {
    self.isSelected = isSelected;
    UIColor *barViewColor = (self.isSelected ? kBar_Selected_Color : kBar_Normal_Color);
    [self.barView setBackgroundColor:barViewColor];
}












@end
