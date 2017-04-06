//
//  LikeListItemCell.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LikeInfo;

@interface LikeListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCreateDtLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeightConstraint;

- (void)setLikeInfo:(LikeInfo *)likeInfo;

@end
