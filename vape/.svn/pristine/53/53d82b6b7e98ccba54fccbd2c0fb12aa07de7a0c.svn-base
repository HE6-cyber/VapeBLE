//
//  ReplyTweetCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "MReplyTweetCell.h"
#import <Masonry/Masonry.h>
#import <MJPhotoBrowser/MJPhotoBrowser.h>
#import "Utility.h"
#import "Tweet.h"

@interface MReplyTweetCell () {
    
    Tweet       *currentTweet;
  
}

@property (strong, nonatomic) UIView      *userInfoBackView;

@property (strong, nonatomic) UIImageView *userIconImgView;

@property (strong, nonatomic) UIView      *userNameAndCreateTimeBackView;
@property (strong, nonatomic) UILabel     *userNameLabel;
@property (strong, nonatomic) UILabel     *createTimeLabel;

@property (strong, nonatomic) UIButton    *deleteButton;

@property (strong, nonatomic) UILabel     *contentLabel;


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

@implementation MReplyTweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *
 **/
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        //===============用户信息显示区域==================
        self.userInfoBackView = [UIView new];
        //用户图像
        self.userIconImgView = [UIImageView new];
        self.userNameAndCreateTimeBackView = [UIView new];
        //用户名称
        self.userNameLabel = [UILabel new];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:14]];
        [self.userNameLabel setTextColor:[UIColor lightGrayColor]];
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
        
        //================文字内容显示区域================
        self.contentLabel = [UILabel new];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentLabel setTextColor:[UIColor darkGrayColor]];
        [self.contentLabel setNumberOfLines:0];
        
        
        //================图片显示区域================
        self.photosBackView = [UIView new];
        
        //图片1
        self.photo1ImgView = [UIImageView new];
        //图片2
        self.photo2ImgView = [UIImageView new];
        //图片2
        self.photo3ImgView = [UIImageView new];
        //图片4
        self.photo4ImgView = [UIImageView new];
        //图片5
        self.photo5ImgView = [UIImageView new];
        //图片6
        self.photo6ImgView = [UIImageView new];
        //图片7
        self.photo7ImgView = [UIImageView new];
        //图片8
        self.photo8ImgView = [UIImageView new];
        //图片9
        self.photo9ImgView = [UIImageView new];
        [self.photosBackView addSubviews:@[self.photo1ImgView, self.photo2ImgView, self.photo3ImgView, self.photo4ImgView, self.photo5ImgView, self.photo6ImgView, self.photo7ImgView, self.photo8ImgView, self.photo9ImgView]];
        
        
        //===============顶部与底部边框线=================
        //顶部边框线
        self.topLine = [UILabel new];
        [self.topLine setBackgroundColor:KBorder_Line_Default_Color];
        //底部边框线
        self.bottomLine = [UILabel new];
        [self.bottomLine setBackgroundColor:KBorder_Line_Default_Color];
        
        [self.contentView addSubviews:@[self.topLine, self.userInfoBackView, self.contentLabel, self.photosBackView, self.bottomLine]];
        
        [self setupMasonryLayout];
        
        //为用户头像设置边框
        self.userIconImgView.layer.cornerRadius = 20;
        self.userIconImgView.layer.borderWidth = 0.5f;
        self.userIconImgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.userIconImgView.clipsToBounds = YES;

        [self setupTweetCell];
        
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [super updateConstraints];
}

/**
 * 设置自动布局
 * 高度： 0.5 + 8 + 40 + 8 + x(文本内容可变) + 8 + kPhoto_WH + 8 + 0.5
 * 宽度： kScreen_Width - (40 + 8*3)
 **/
- (void)setupMasonryLayout {
    __weak typeof(self) weakSelf = self;
    
    //顶部边框线
    [self.topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(kBorder_Line_WH);
    }];
    
    //===============用户信息区域布局=================
    [self.userInfoBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.equalTo(self.contentView).offset(kEdge_Width);
        make.trailing.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(40);
    }];
    
    [self.userIconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.bottom.equalTo(weakSelf.userInfoBackView);
        make.width.equalTo(weakSelf.userIconImgView.mas_height);
    }];
    
    [self.userNameAndCreateTimeBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.userInfoBackView).offset(kEdge_Width/4);
        make.leading.equalTo(weakSelf.userIconImgView.mas_trailing).offset(kEdge_Width);
        make.bottom.equalTo(weakSelf.userInfoBackView).offset(-kEdge_Width/4);
        make.trailing.equalTo(weakSelf.userInfoBackView).offset(-kEdge_Width);
    }];
    
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.trailing.equalTo(weakSelf.userNameAndCreateTimeBackView);
    }];
    
    [self.createTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.and.bottom.equalTo(weakSelf.userNameAndCreateTimeBackView);
    }];
    
    [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.userInfoBackView);
        make.centerY.equalTo(weakSelf.userInfoBackView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    //================文字内容显示区域的布局================
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.userInfoBackView.mas_bottom).offset(kEdge_Width);
        make.leading.equalTo(weakSelf.userNameAndCreateTimeBackView);
        make.trailing.equalTo(self.contentView).offset(-kEdge_Width);
    }];
    
    //================图片显示区域的布局================
    [self.photosBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(kEdge_Width);
        make.leading.equalTo(weakSelf.userNameAndCreateTimeBackView);
        make.trailing.equalTo(self.contentView).offset(-kEdge_Width);
        make.height.mas_equalTo(kPhoto_WH);
    }];
    
    [self.photo1ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo1ImgView.mas_height);
    }];
    
    [self.photo2ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo2ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo1ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo3ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo3ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo2ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo4ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo4ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo3ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo5ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo5ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo4ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo6ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo6ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo5ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo7ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo7ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo6ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo8ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo8ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo7ImgView.mas_trailing).offset(1);
    }];
    
    [self.photo9ImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.photosBackView);
        make.width.equalTo(weakSelf.photo9ImgView.mas_height);
        make.leading.equalTo(weakSelf.photo8ImgView.mas_trailing).offset(1);
    }];
    
    //底部边框线
    [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.and.bottom.equalTo(self.contentView);
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
    
    [self.contentLabel setText:tweet.content];
    
    //=====================只有Tweet的userId是当前用户时，才显示删除按钮========================
    if (tweet.userId == [UserHelper currentUserId]) {
        [self.deleteButton setHidden:NO];
        [self.deleteButton setEnabled:YES];
    }
    else {
        [self.deleteButton setHidden:YES];
        [self.deleteButton setEnabled:NO];
    }
    
    if ([[tweet getPhotoUrls] count] == 0) {
        [self.photosBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    else {
        [self.photosBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kPhoto_WH);
        }];
    }
    
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
 * 计算单元格的内容视图高度
 **/
+ (CGFloat)calculateContentViewHeightByReplyTweet:(Tweet *)replyTweet {
    NSString *replyTextContent = replyTweet.content != nil ? replyTweet.content : @"";
    CGFloat textContentWidth = kScreen_Width - (40+kEdge_Width*3);
    CGFloat textContentHeight = [replyTextContent calculateSize:CGSizeMake(textContentWidth, CGFLOAT_MAX)
                                                           Font:[UIFont systemFontOfSize:14]].height;
    CGFloat heightOfphotosBackView = [[replyTweet getPhotoUrls] count] == 0 ? 0 : kPhoto_WH;
    CGFloat heightOfcontentView = kBorder_Line_WH + kEdge_Width + 40 + kEdge_Width + textContentHeight + kEdge_Width + heightOfphotosBackView + kEdge_Width + kBorder_Line_WH;
    
    return heightOfcontentView;
}




/**
 * 删除按钮的点击事件处理方法
 **/
- (void)onDeleteButton:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replyTweetCell:didDeleteTweet:)]) {
        [self.delegate replyTweetCell:self didDeleteTweet:currentTweet];
    }
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
