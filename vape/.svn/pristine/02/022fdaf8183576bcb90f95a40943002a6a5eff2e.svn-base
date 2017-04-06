//
//  TweetCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "TweetCell.h"
#import <MJPhotoBrowser/MJPhotoBrowser.h>
#import "Utility.h"
#import "Tweet.h"

#define kPhoto_1_WH          (kScreen_Width - 16)                //一行只有1张图片时的图片宽度
#define kPhoto_2_WH          ((kScreen_Width - 16 - 4)/2)        //一行只有2张图片时的图片宽度
#define kPhoto_3_WH          ((kScreen_Width - 16 - 4 - 4)/3)    //一行只有3张图片时的图片宽度

static NSString *const kLikeIcon_ImageName  = @"Like";
static NSString *const kLikedIcon_ImageName = @"Liked";

@interface TweetCell () {
    Tweet       *currentTweet;
}

@property (strong, nonatomic) UIView      *userInfoBackView;

@property (strong, nonatomic) UIImageView *userIconImgView;

@property (strong, nonatomic) UIView      *userNameAndCreateTimeBackView;
@property (strong, nonatomic) UILabel     *userNameLabel;
@property (strong, nonatomic) UILabel     *createTimeLabel;

@property (strong, nonatomic) UIButton    *deleteButton;

@property (strong, nonatomic) UILabel     *contentLabel;

@property (strong, nonatomic) UIView      *bottomView;

@property (strong, nonatomic) UIView      *replyInfoBackView;
@property (strong, nonatomic) UIImageView *bubbleImgView;
@property (strong, nonatomic) UILabel     *replyCountLabel;
@property (strong, nonatomic) UIButton    *replyButton;

@property (strong, nonatomic) UIView      *likeInfoBackView;
@property (strong, nonatomic) UIImageView *likeImgView;
@property (strong, nonatomic) UILabel     *likeTitleLabel;
@property (strong, nonatomic) UIButton    *likeButton;

@property (strong, nonatomic) UILabel     *topLine;
@property (strong, nonatomic) UILabel     *bottomLine;

@property (strong, nonatomic) UIView      *userAddressBackView;
@property (strong, nonatomic) UIImageView *userAddressImgView;
@property (strong, nonatomic) UILabel     *userAddressLabel;


@property (strong, nonatomic) UIView      *photosBackView;

@property (strong, nonatomic) UIImageView *photo1ImgView;
@property (strong, nonatomic) UIImageView *photo2ImgView;
@property (strong, nonatomic) UIImageView *photo3ImgView;
@property (strong, nonatomic) UIImageView *photo4ImgView;
@property (strong, nonatomic) UIImageView *photo5ImgView;
@property (strong, nonatomic) UIImageView *photo6ImgView;
@property (strong, nonatomic) UIImageView *photo7ImgView;
@property (strong, nonatomic) UIImageView *photo8ImgView;
@property (strong, nonatomic) UIImageView *photo9ImgView;


@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier CellType:(TweetCellType)cellType {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.cellType = cellType;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        //===============用户信息显示区域==================
        self.userInfoBackView = [UIView new];
        //用户图像
        self.userIconImgView = [UIImageView new];
        self.userNameAndCreateTimeBackView = [UIView new];
        //用户名称
        self.userNameLabel = [UILabel new];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.userNameLabel setTextColor:[UIColor darkGrayColor]];
        //信息的创建时间
        self.createTimeLabel = [UILabel new];
        [self.createTimeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.createTimeLabel setTextColor:[UIColor lightGrayColor]];
        
        //删除按钮
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.deleteButton setTitle:LOCALIZED_STRING(keyDelete) forState:UIControlStateNormal];//@"删除"
        [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.userNameAndCreateTimeBackView addSubviews:@[self.userNameLabel, self.createTimeLabel]];
        [self.userInfoBackView addSubviews:@[self.userIconImgView, self.userNameAndCreateTimeBackView, self.deleteButton]];
        
        //==================================================中间的显示图片区域=====================================================
        self.photosBackView = [UIView new];
        
        switch (self.cellType) {
            case TweetCellTypeOnePhoto: {
                self.photo1ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView]];
            }
                break;
            case TweetCellTypeTwoPhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView]];
            }
                break;
            case TweetCellTypeThreePhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView]];
            }
                break;
            case TweetCellTypeFourPhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                self.photo4ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView]];
            }
                break;
            case TweetCellTypeFivePhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                self.photo4ImgView = [UIImageView new];
                self.photo5ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView, self.photo5ImgView]];
            }
                break;
            case TweetCellTypeSixPhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                self.photo4ImgView = [UIImageView new];
                self.photo5ImgView = [UIImageView new];
                self.photo6ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView, self.photo5ImgView, self.photo6ImgView]];
            }
                break;
            case TweetCellTypeSevenPhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                self.photo4ImgView = [UIImageView new];
                self.photo5ImgView = [UIImageView new];
                self.photo6ImgView = [UIImageView new];
                self.photo7ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView, self.photo5ImgView, self.photo6ImgView, self.photo7ImgView]];
            }
                break;
            case TweetCellTypeEightPhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                self.photo4ImgView = [UIImageView new];
                self.photo5ImgView = [UIImageView new];
                self.photo6ImgView = [UIImageView new];
                self.photo7ImgView = [UIImageView new];
                self.photo8ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView, self.photo5ImgView, self.photo6ImgView, self.photo7ImgView, self.photo8ImgView]];
            }
                break;
            case TweetCellTypeNinePhotos: {
                self.photo1ImgView = [UIImageView new];
                self.photo2ImgView = [UIImageView new];
                self.photo3ImgView = [UIImageView new];
                self.photo4ImgView = [UIImageView new];
                self.photo5ImgView = [UIImageView new];
                self.photo6ImgView = [UIImageView new];
                self.photo7ImgView = [UIImageView new];
                self.photo8ImgView = [UIImageView new];
                self.photo9ImgView = [UIImageView new];
                [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView, self.photo5ImgView, self.photo6ImgView, self.photo7ImgView, self.photo8ImgView, self.photo9ImgView]];
            }
                break;
        }
        //==================================================中间的显示图片区域=====================================================
        
        
        
        //================文字内容显示区域================
        self.contentLabel = [UILabel new];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentLabel setTextColor:[UIColor darkGrayColor]];
        [self.contentLabel setNumberOfLines:0];
        
        //================回复信息显示区域的布局================
        self.replyInfoBackView = [UIView new];
        
        self.bubbleImgView = [UIImageView new];
        [self.bubbleImgView setImage:[UIImage imageNamed:@"bubble"]];
        //信息回复数量
        self.replyCountLabel = [UILabel new];
        [self.replyCountLabel setFont:[UIFont systemFontOfSize:12]];
        [self.replyCountLabel setTextColor:[UIColor lightGrayColor]];
        [self.replyCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyButton addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.replyInfoBackView addSubviews:@[self.bubbleImgView, self.replyCountLabel, self.replyButton]];
        
        //================点赞信息显示区域的布局================
        self.likeInfoBackView = [UIView new];
        
        self.likeImgView = [UIImageView new];
        [self.likeImgView setImage:[UIImage imageNamed:kLikeIcon_ImageName]];
        
        self.likeTitleLabel = [UILabel new];
        [self.likeTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.likeTitleLabel setTextColor:[UIColor lightGrayColor]];
        [self.likeTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.likeTitleLabel setText:LOCALIZED_STRING(keyLike)];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton addTarget:self action:@selector(onLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.likeInfoBackView addSubviews:@[self.likeImgView, self.likeTitleLabel, self.likeButton]];
        
        //================用户位置================
        self.userAddressBackView = [UIView new];
        
        self.userAddressImgView = [UIImageView new];
        [self.userAddressImgView setImage:[UIImage imageNamed:@"discovery_location"]];
        
        self.userAddressLabel = [UILabel new];
        [self.userAddressLabel setFont:[UIFont systemFontOfSize:12]];
        [self.userAddressLabel setTextColor:[UIColor lightGrayColor]];
        [self.userAddressLabel setTextAlignment:NSTextAlignmentLeft];
        
        [self.userAddressBackView addSubviews:@[self.userAddressImgView, self.userAddressLabel]];
        
        
        self.bottomView = [UIView new];
        [self.bottomView addSubviews:@[self.userAddressBackView, self.likeInfoBackView, self.replyInfoBackView]];
        
        //===============顶部与底部边框线=================
        self.topLine = [UILabel new];
        [self.topLine setBackgroundColor:KBorder_Line_Default_Color];
        self.bottomLine = [UILabel new];
        [self.bottomLine setBackgroundColor:KBorder_Line_Default_Color];
        
        [self.contentView addSubviews:@[self.topLine, self.userInfoBackView, self.photosBackView, self.contentLabel, self.bottomView, self.bottomLine]];
        
        [self setupMasonryLayout];
        
        //为用户头像设置边框
        self.userIconImgView.layer.cornerRadius = 24;
        self.userIconImgView.layer.borderWidth = 0.5f;
        self.userIconImgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.userIconImgView.clipsToBounds = YES;
        
        //为回复信息显示区域设置边框
        self.replyInfoBackView.layer.cornerRadius = 15.f;
        self.replyInfoBackView.layer.borderWidth = 0.5f;
        self.replyInfoBackView.layer.borderColor = KBorder_Line_Default_Color.CGColor;
        self.replyInfoBackView.clipsToBounds = YES;
        
        //为点赞信息显示区域设置边框
        self.likeInfoBackView.layer.cornerRadius = 15.f;
        self.likeInfoBackView.layer.borderWidth = 0.5f;
        self.likeInfoBackView.layer.borderColor = KBorder_Line_Default_Color.CGColor;
        self.likeInfoBackView.clipsToBounds = YES;
        
        [self setupTweetCell];
    }
    return self;
}

/**
 * 设置自动布局
 * 高度： 0.5 + 60 + x(图片区域高度，随图片个数变化) + 8 + x(文本内容可变) + 8 + 38 + 0.5
 * 宽度： kScreen_Width - (8*2)
 **/
- (void)setupMasonryLayout {
    __weak typeof(self) weakSelf = self;
    //顶部边框线
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.trailing.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(kBorder_Line_WH);
    }];
    
    //===============用户信息区域布局=================
    [self.userInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLine.mas_bottom);
        make.leading.and.trailing.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(60);
    }];
    
    [self.userIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.userInfoBackView).offset(kEdge_Width);
        make.centerY.equalTo(weakSelf.userInfoBackView);
        make.width.mas_equalTo(48);
        make.height.equalTo(weakSelf.userIconImgView.mas_width);
    }];
    
    [self.userNameAndCreateTimeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.userIconImgView.mas_trailing).offset(kEdge_Width);
        make.trailing.equalTo(weakSelf.userInfoBackView).offset(-kEdge_Width);
        make.height.equalTo(weakSelf.userInfoBackView).multipliedBy(0.6);
        make.centerY.equalTo(weakSelf.userInfoBackView);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.trailing.equalTo(weakSelf.userNameAndCreateTimeBackView);
    }];
    
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.and.trailing.equalTo(weakSelf.userNameAndCreateTimeBackView);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.userInfoBackView);
        make.centerY.equalTo(weakSelf.userInfoBackView);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    
    
    //==================================================中间的显示图片区域的布局=====================================================
    switch (self.cellType) {
        case TweetCellTypeOnePhoto: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_1_WH);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.and.bottom.and.trailing.equalTo(weakSelf.photosBackView);
            }];
        }
            break;
        case TweetCellTypeTwoPhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_2_WH);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.and.bottom.equalTo(weakSelf.photosBackView);
                make.width.mas_equalTo(kPhoto_2_WH);
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.width.mas_equalTo(kPhoto_2_WH);
            }];
            
        }
            break;
        case TweetCellTypeThreePhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_3_WH);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.and.leading.equalTo(weakSelf.photosBackView);
                make.width.mas_equalTo(kPhoto_3_WH);
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.and.centerX.equalTo(weakSelf.photosBackView);
                make.width.mas_equalTo(kPhoto_3_WH);
            }];
        
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.width.mas_equalTo(kPhoto_3_WH);
            }];
            
        }
            break;
        case TweetCellTypeFourPhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_2_WH*2+kMiddleSeparator_Width);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo4ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
        }
            break;
        case TweetCellTypeFivePhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_2_WH+kPhoto_3_WH+kMiddleSeparator_Width);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo4ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo5ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
        }
            break;
        case TweetCellTypeSixPhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_3_WH*2+kMiddleSeparator_Width);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo4ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo5ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo6ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
        }
            break;
        case TweetCellTypeSevenPhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_2_WH*2+kPhoto_3_WH+kMiddleSeparator_Width*2);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.photo1ImgView.mas_bottom).offset(kMiddleSeparator_Width);
                make.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo4ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.photo1ImgView.mas_bottom).offset(kMiddleSeparator_Width);
                make.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo5ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.bottom.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo6ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo7ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
        }
            break;
        case TweetCellTypeEightPhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_2_WH+kPhoto_3_WH*2+kMiddleSeparator_Width*2);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_2_WH, kPhoto_2_WH));
            }];
            
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.photo1ImgView.mas_bottom).offset(kMiddleSeparator_Width);
                make.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo4ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.photo1ImgView.mas_bottom).offset(kMiddleSeparator_Width);
                make.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo5ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.photo1ImgView.mas_bottom).offset(kMiddleSeparator_Width);
                make.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo6ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.bottom.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo7ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo8ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
        }
            break;
        case TweetCellTypeNinePhotos: {
            [self.photosBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.userInfoBackView.mas_bottom);
                make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
                make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
                make.height.mas_equalTo(kPhoto_3_WH*3+kMiddleSeparator_Width*2);
            }];
            
            [self.photo1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo3ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo4ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.centerY.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo5ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.centerY.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo6ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.and.centerY.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo7ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.leading.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo8ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.centerX.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
            [self.photo9ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.and.trailing.equalTo(weakSelf.photosBackView);
                make.size.mas_equalTo(CGSizeMake(kPhoto_3_WH, kPhoto_3_WH));
            }];
            
        }
            break;
    }
    //==================================================中间的显示图片区域的布局=====================================================
    
    
    
    //================文字内容显示区域的布局================
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.photosBackView.mas_bottom).offset(kEdge_Width);
        make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
        make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
    }];
    
    //================用户位置显示区域与回复数显示区的父视图================
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(kEdge_Width);
        make.bottom.equalTo(weakSelf.bottomLine.mas_top);
        make.leading.equalTo(weakSelf.contentView).offset(kEdge_Width);
        make.trailing.equalTo(weakSelf.contentView).offset(-kEdge_Width);
        make.height.mas_equalTo(38);
    }];
    
    //================回复信息显示区域的布局================
    [self.replyInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.trailing.equalTo(weakSelf.bottomView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.bubbleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.replyInfoBackView).offset(kEdge_Width);
        make.centerY.equalTo(weakSelf.replyInfoBackView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.bubbleImgView.mas_trailing);
        make.trailing.equalTo(weakSelf.replyInfoBackView);
        make.centerY.equalTo(weakSelf.replyInfoBackView);
    }];
    
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.leading.and.trailing.equalTo(weakSelf.replyInfoBackView);
    }];
    
    //================点赞信息显示区域的布局================
    [self.likeInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView);
        make.trailing.equalTo(weakSelf.replyInfoBackView.mas_leading).offset(-kEdge_Width);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.likeInfoBackView).offset(kEdge_Width);
        make.centerY.equalTo(weakSelf.likeInfoBackView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.likeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.likeImgView.mas_trailing);
        make.trailing.equalTo(weakSelf.likeInfoBackView);
        make.centerY.equalTo(weakSelf.likeInfoBackView);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.leading.and.trailing.equalTo(weakSelf.likeInfoBackView);
    }];
    
    //================用户位置显示区域的布局================
    [self.userAddressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.equalTo(weakSelf.bottomView);
        make.trailing.equalTo(weakSelf.likeInfoBackView.mas_leading).offset(-kEdge_Width);
        make.height.mas_equalTo(30);
    }];
    
    [self.userAddressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.userAddressBackView);
        make.centerY.equalTo(weakSelf.userAddressBackView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.userAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.trailing.equalTo(weakSelf.userAddressBackView);
        make.leading.equalTo(weakSelf.userAddressImgView.mas_trailing).offset(kEdge_Width/4);
    }];
    
    
    //底部边框线
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.and.trailing.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(kBorder_Line_WH);
    }];
    
    
}


/**
 * 设置单元格的显示内容
 **/
- (void)setCurrentTweet:(Tweet *)tweet {
    currentTweet = tweet;
    
    [self.userNameLabel setText:tweet.userName];
    [self.userIconImgView sd_setImageWithURL:[NSURL URLWithString:tweet.userIconUrl] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.createTimeLabel setText:[tweet.createTime stringWithFormat:@"yyyy/MM/dd HH:mm"]];
    
    //=====================设置回复信息========================
    [self.contentLabel setText:tweet.content];
    [self.replyCountLabel setText:[NSString stringWithFormat:@"%ld", (long)tweet.replyCount]];
    
    //=====================设置作者位置信息========================
    if (tweet.address != nil && ![tweet.address isEqualToString:@""]) {
        [self.userAddressBackView setHidden:NO];
    }
    else {
        [self.userAddressBackView setHidden:YES];
    }
    [self.userAddressLabel setText:tweet.address];
    
    //=====================只有Tweet的userId是当前用户时，才显示删除按钮========================
    if (tweet.userId == [UserHelper currentUserId]) {
        [self.deleteButton setHidden:NO];
        [self.deleteButton setEnabled:YES];
    }
    else {
        [self.deleteButton setHidden:YES];
        [self.deleteButton setEnabled:NO];
    }
    
    //=====================设置点赞信息========================
    [self.likeImgView setImage:[UIImage imageNamed:(tweet.isLike ? kLikedIcon_ImageName : kLikeIcon_ImageName)]];
    [self.likeTitleLabel setText:tweet.likeCount > 0 ?[NSString stringWithFormat:@"%ld", (long)tweet.likeCount] : LOCALIZED_STRING(keyLike)];
  
    
    
    //=====================显示图片========================
    [self.photo1ImgView setHidden:(tweet.photo1Url == nil || [tweet.photo1Url isEqualToString:@""])];
    [self.photo2ImgView setHidden:(tweet.photo2Url == nil || [tweet.photo2Url isEqualToString:@""])];
    [self.photo3ImgView setHidden:(tweet.photo3Url == nil || [tweet.photo3Url isEqualToString:@""])];
    [self.photo4ImgView setHidden:(tweet.photo4Url == nil || [tweet.photo4Url isEqualToString:@""])];
    [self.photo5ImgView setHidden:(tweet.photo5Url == nil || [tweet.photo5Url isEqualToString:@""])];
    [self.photo6ImgView setHidden:(tweet.photo6Url == nil || [tweet.photo6Url isEqualToString:@""])];
    [self.photo7ImgView setHidden:(tweet.photo7Url == nil || [tweet.photo7Url isEqualToString:@""])];
    [self.photo8ImgView setHidden:(tweet.photo8Url == nil || [tweet.photo8Url isEqualToString:@""])];
    [self.photo9ImgView setHidden:(tweet.photo9Url == nil || [tweet.photo9Url isEqualToString:@""])];
    
    [self.photo1ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo1Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo2ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo2Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo3ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo3Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo4ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo4Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo5ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo5Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo6ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo6Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo7ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo7Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo8ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo8Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];
    [self.photo9ImgView sd_setImageWithURL:[NSURL URLWithString:tweet.photo9Url] placeholderImage:[UIImage imageNamed:kDiscovery_PlaceholderImg]];

}

/**
 * 删除按钮的点击事件处理方法
 **/
- (void)onDeleteButton:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tweetCell:didDeleteTweet:)]) {
        [self.delegate tweetCell:self didDeleteTweet:currentTweet];
    }
}

/**
 * 回复按钮的点击事件处理方法
 **/
- (void)onReplyButton:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tweetCell:didReplyTweet:)]) {
        [self.delegate tweetCell:self didReplyTweet:currentTweet];
    }
}

/**
 * 点赞按钮的点击事件处理方法
 **/
- (void)onLikeButton:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tweetCell:didLikeTweet:)]) {
        [self.delegate tweetCell:self didLikeTweet:currentTweet];
    }
}

/**
 * 计算单元格的内容视图高度
 **/
+ (CGFloat)calculateContentViewHeightByReplyTweet:(Tweet *)replyTweet {
    NSString *replyTextContent = replyTweet.content != nil ? replyTweet.content : @"";
    CGFloat textContentWidth = kScreen_Width - kEdge_Width*2;
    CGFloat textContentHeight = [replyTextContent calculateSize:CGSizeMake(textContentWidth, CGFLOAT_MAX)
                                                           Font:[UIFont systemFontOfSize:14]].height;
    CGFloat heightOfPhotosBackView = 0;
    if ([[replyTweet getPhotoUrls] count] == 1) {
        heightOfPhotosBackView = kPhoto_1_WH;
    }
    else if ([[replyTweet getPhotoUrls] count] == 2) {
        heightOfPhotosBackView = kPhoto_2_WH;
    }
    else if ([[replyTweet getPhotoUrls] count] == 3) {
        heightOfPhotosBackView = kPhoto_3_WH;
    }
    else if ([[replyTweet getPhotoUrls] count] == 4) {
        heightOfPhotosBackView = kPhoto_2_WH*2 + kMiddleSeparator_Width;
    }
    else if ([[replyTweet getPhotoUrls] count] == 5) {
        heightOfPhotosBackView = kPhoto_2_WH + kPhoto_3_WH + kMiddleSeparator_Width;
    }
    else if ([[replyTweet getPhotoUrls] count] == 6) {
        heightOfPhotosBackView = kPhoto_3_WH*2 + kMiddleSeparator_Width;
    }
    else if ([[replyTweet getPhotoUrls] count] == 7) {
        heightOfPhotosBackView = kPhoto_2_WH*2 + kPhoto_3_WH + kMiddleSeparator_Width*2;
    }
    else if ([[replyTweet getPhotoUrls] count] == 8) {
        heightOfPhotosBackView = kPhoto_2_WH + kPhoto_3_WH*2 + kMiddleSeparator_Width*2;
    }
    else if ([[replyTweet getPhotoUrls] count] == 9) {
        heightOfPhotosBackView = kPhoto_3_WH*3 + kMiddleSeparator_Width*2;
    }
    
    //高度： 0.5 + 60 + x(图片区域高度，随图片个数变化) + 8 + x(文本内容可变) + 8 + 38 + 0.5
    CGFloat heightOfcontentView = kBorder_Line_WH + 60 + heightOfPhotosBackView + kEdge_Width + textContentHeight + kEdge_Width + 38 + kBorder_Line_WH;
    
    return heightOfcontentView;
}



+ (CGFloat)calculateContentViewHeightByReplyTweet:(Tweet *)replyTweet MaxHeightOfTextContent:(CGFloat)maxHeightOfTextContent {
    NSString *replyTextContent = replyTweet.content != nil ? replyTweet.content : @"";
    CGFloat textContentWidth = kScreen_Width - kEdge_Width*2;
    CGFloat textContentHeight = [replyTextContent calculateSize:CGSizeMake(textContentWidth, CGFLOAT_MAX)
                                                           Font:[UIFont systemFontOfSize:14]].height;
    textContentHeight = (textContentHeight > maxHeightOfTextContent ? maxHeightOfTextContent : textContentHeight);

    CGFloat heightOfPhotosBackView = 0;
    if ([[replyTweet getPhotoUrls] count] == 1) {
        heightOfPhotosBackView = kPhoto_1_WH;
    }
    else if ([[replyTweet getPhotoUrls] count] == 2) {
        heightOfPhotosBackView = kPhoto_2_WH;
    }
    else if ([[replyTweet getPhotoUrls] count] == 3) {
        heightOfPhotosBackView = kPhoto_3_WH;
    }
    else if ([[replyTweet getPhotoUrls] count] == 4) {
        heightOfPhotosBackView = kPhoto_2_WH*2 + kMiddleSeparator_Width;
    }
    else if ([[replyTweet getPhotoUrls] count] == 5) {
        heightOfPhotosBackView = kPhoto_2_WH + kPhoto_3_WH + kMiddleSeparator_Width;
    }
    else if ([[replyTweet getPhotoUrls] count] == 6) {
        heightOfPhotosBackView = kPhoto_3_WH*2 + kMiddleSeparator_Width;
    }
    else if ([[replyTweet getPhotoUrls] count] == 7) {
        heightOfPhotosBackView = kPhoto_2_WH*2 + kPhoto_3_WH + kMiddleSeparator_Width*2;
    }
    else if ([[replyTweet getPhotoUrls] count] == 8) {
        heightOfPhotosBackView = kPhoto_2_WH + kPhoto_3_WH*2 + kMiddleSeparator_Width*2;
    }
    else if ([[replyTweet getPhotoUrls] count] == 9) {
        heightOfPhotosBackView = kPhoto_3_WH*3 + kMiddleSeparator_Width*2;
    }
    
    //高度： 0.5 + 60 + x(图片区域高度，随图片个数变化) + 8 + x(文本内容可变) + 8 + 38 + 0.5
    CGFloat heightOfcontentView = kBorder_Line_WH + 60 + heightOfPhotosBackView + kEdge_Width + textContentHeight + kEdge_Width + 38 + kBorder_Line_WH;
    
    return heightOfcontentView;
}



//==========================================================================
#pragma mark - 点击图片显示大图的操作
//==========================================================================

/**
 * 显示大图
 **/
- (void)showBigImageByCurrentPageIndex:(NSInteger)currentPageIndex {
    if (currentTweet != nil && [currentTweet getPhotosCount] > 0) {
        //显示大图
        NSMutableArray *bigPhotos = [NSMutableArray new];
        for (NSString *photoUrl in [currentTweet getPhotoUrls]) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:photoUrl]; // 图片路径
            [bigPhotos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = currentPageIndex; // 弹出相册时显示的第一张图片是？
        browser.photos = bigPhotos; // 设置所有的图片
        browser.showSaveBtn = false;
        [browser show];
    }
}


/**
 * 设置单元格
 **/
- (void)setupTweetCell {
    
    //=====================为图片添加点击手势========================
    self.photo1ImgView.userInteractionEnabled = YES;
    self.photo2ImgView.userInteractionEnabled = YES;
    self.photo3ImgView.userInteractionEnabled = YES;
    self.photo4ImgView.userInteractionEnabled = YES;
    self.photo5ImgView.userInteractionEnabled = YES;
    self.photo6ImgView.userInteractionEnabled = YES;
    self.photo7ImgView.userInteractionEnabled = YES;
    self.photo8ImgView.userInteractionEnabled = YES;
    self.photo9ImgView.userInteractionEnabled = YES;
    [self.photo1ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto1TapGesture:)]];
    [self.photo2ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto2TapGesture:)]];
    [self.photo3ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto3TapGesture:)]];
    [self.photo4ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto4TapGesture:)]];
    [self.photo5ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto5TapGesture:)]];
    [self.photo6ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto6TapGesture:)]];
    [self.photo7ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto7TapGesture:)]];
    [self.photo8ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto8TapGesture:)]];
    [self.photo9ImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoto9TapGesture:)]];
    
    
    self.photo1ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo1ImgView.clipsToBounds        = YES;
    
    self.photo2ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo2ImgView.clipsToBounds        = YES;
    
    self.photo3ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo3ImgView.clipsToBounds        = YES;
    
    self.photo4ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo4ImgView.clipsToBounds        = YES;
    
    self.photo5ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo5ImgView.clipsToBounds        = YES;
    
    self.photo6ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo6ImgView.clipsToBounds        = YES;
    
    self.photo7ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo7ImgView.clipsToBounds        = YES;
    
    self.photo8ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo8ImgView.clipsToBounds        = YES;
    
    self.photo9ImgView.contentMode          = UIViewContentModeScaleAspectFill;
    self.photo9ImgView.clipsToBounds        = YES;
}


- (void)handlePhoto1TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:0];
}

- (void)handlePhoto2TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:1];
}

- (void)handlePhoto3TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:2];
}

- (void)handlePhoto4TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:3];
}

- (void)handlePhoto5TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:4];
}

- (void)handlePhoto6TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:5];
}

- (void)handlePhoto7TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:6];
}

- (void)handlePhoto8TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:7];
}

- (void)handlePhoto9TapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self showBigImageByCurrentPageIndex:8];
}








@end
