//
//  LikeListItemCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LikeListItemCell.h"
#import "Utility.h"
#import "LikeInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LikeListItemCell ()

@property (strong, nonatomic) LikeInfo *pLikeInfo;

@end

@implementation LikeListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomLineHeightConstraint.constant = kBorder_Line_WH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setLikeInfo:(LikeInfo *)likeInfo {
    self.pLikeInfo = likeInfo;
    if (likeInfo != nil) {
        [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:likeInfo.authorPhotoUrl] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
        [self.userNameLabel setText:likeInfo.author];
        [self.likeCreateDtLabel setText:[likeInfo.createDt stringWithFormat:@"yyyy/MM/dd HH:mm"]];
        
    }
}

@end
