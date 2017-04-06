//
//  LikeCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LikeCell.h"
#import "Utility.h"
#import "LikeInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPhoto_Count_iPhone5            6
#define kPhoto_count_iPhone6            7
#define kPhoto_count_iPhone6P           8

#define kPhoto_StartTagValue            90001

@interface LikeCell ()

@property (strong, nonatomic) UIView    *titleBackView;
@property (strong, nonatomic) UILabel   *titleLabel;

@property (strong, nonatomic) UIView    *photosBackView;

@property (assign, nonatomic) NSInteger photoCount;
@property (assign, nonatomic) CGFloat   photoBackViewHW;

@end

@implementation LikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        __weak typeof(self) weakSelf = self;
        switch (kiPhone_Version) {
            case kiPhone_5_5:
                self.photoCount = kPhoto_count_iPhone6P;
                break;
            case kiPhone_4_7:
                self.photoCount = kPhoto_count_iPhone6;
                break;
            default:
                self.photoCount = kPhoto_Count_iPhone5;
                break;
        }
        self.photoBackViewHW = (kScreen_Width - kMargin_WH)/self.photoCount;
        
        //==========================标题区域===============================
        self.titleBackView = [UIView new];
        [self.contentView addSubview:self.titleBackView];
        [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.equalTo(weakSelf.contentView);
            make.leading.equalTo(weakSelf.contentView).offset(kMargin_WH);
            make.trailing.equalTo(weakSelf.contentView).offset(-kMargin_WH);
        }];
        
        self.titleLabel = [UILabel new];
        [self.titleBackView addSubview:self.titleLabel];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.centerY.equalTo(weakSelf.titleBackView);
        }];
        
        //==========================图片区域===============================
        self.photosBackView = [UIView new];
        [self.contentView addSubview:self.photosBackView];
        [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleBackView.mas_bottom);
            make.bottom.equalTo(weakSelf.contentView).offset(-kMargin_WH*2);
            make.leading.equalTo(weakSelf.contentView).offset(kMargin_WH/2);
            make.trailing.equalTo(weakSelf.contentView).offset(-kMargin_WH/2);
        }];
        
        NSMutableArray *subViews = [NSMutableArray new];
        for (NSInteger index = 0; index < self.photoCount; index++) {
            UIView *subView = [UIView new];
            [self.photosBackView addSubview:subView];
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(weakSelf.photoBackViewHW, weakSelf.photoBackViewHW));
                make.centerY.equalTo(weakSelf.photosBackView);
                make.leading.equalTo(weakSelf.photosBackView).offset(weakSelf.photoBackViewHW*index);
            }];
            [subViews addObject:subView];
        }
        
        for (NSInteger index = 0; index < subViews.count; index++) {
            UIView *subView = subViews[index];
            UIImageView *photoImgView = [UIImageView new];
            [subView addSubview:photoImgView];
            [photoImgView setTag:kPhoto_StartTagValue + index];
            [photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(subView).offset(kMargin_WH/2);
                make.trailing.equalTo(subView).offset(-kMargin_WH/2);
                make.centerY.equalTo(subView);
                make.height.equalTo(photoImgView.mas_width);
            }];
            [photoImgView setImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
            photoImgView.layer.cornerRadius = (self.photoBackViewHW - kMargin_WH)/2.f;
            photoImgView.clipsToBounds = YES;
        }
    }
    return self;
}

/**
 * 计算单元格的内容视图高度
 **/
+ (CGFloat)calculateContentViewHeight {
    NSInteger photoCount = kPhoto_Count_iPhone5;
    switch (kiPhone_Version) {
        case kiPhone_5_5:
            photoCount = kPhoto_count_iPhone6P;
            break;
        case kiPhone_4_7:
            photoCount = kPhoto_count_iPhone6;
            break;
    }
    
    CGFloat heightOfContentView = 40 + (kScreen_Width - kMargin_WH)/photoCount + kMargin_WH;
    
    return heightOfContentView;
}


- (void)setLikeInfos:(NSArray *)likeInfos LikeCount:(NSInteger)likeCount {
    [self.titleLabel setText:[NSString stringWithFormat:LOCALIZED_STRING(key_PeopleLiked), (long)likeCount]];
    for (NSInteger index = 0; index<self.photoCount; index++) {
        UIImageView *photoImgView = [self.photosBackView viewWithTag:kPhoto_StartTagValue+index];
        if (index == self.photoCount-1) {
            [photoImgView setHidden:NO];
            [photoImgView setImage:[UIImage imageNamed:@"Like_More"]];
        }
        else {
            if (likeInfos.count>index) {
                LikeInfo *likeInfo = likeInfos[index];
                [photoImgView sd_setImageWithURL:[NSURL URLWithString:likeInfo.authorPhotoUrl] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
                [photoImgView setHidden:NO];
            }
            else {
                [photoImgView setHidden:YES];
            }
        }
    }
}


@end
