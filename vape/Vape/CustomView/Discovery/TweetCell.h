//
//  TweetCell.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kEdge_Width                         8   //边缘的分隔区域宽度
#define kMiddleSeparator_Width              4   //图片中间分隔区域的宽度

//======================================
// 单元格类型
//======================================
typedef NS_ENUM(NSInteger, TweetCellType) {
    TweetCellTypeOnePhoto,
    TweetCellTypeTwoPhotos,
    TweetCellTypeThreePhotos,
    TweetCellTypeFourPhotos,
    TweetCellTypeFivePhotos,
    TweetCellTypeSixPhotos,
    TweetCellTypeSevenPhotos,
    TweetCellTypeEightPhotos,
    TweetCellTypeNinePhotos
};

@class Tweet;
@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell {
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier CellType:(TweetCellType)cellType;

@property (assign, nonatomic) TweetCellType cellType;

@property (weak, nonatomic) id<TweetCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath   *indexPath;



- (void)setCurrentTweet:(Tweet *)tweet;

/** 计算单元格的内容视图高度 */
+ (CGFloat)calculateContentViewHeightByReplyTweet:(Tweet *)replyTweet;


/** 根据Tweet对象与文本内容的最大高度来计算单元格内容视图的高度 */
+ (CGFloat)calculateContentViewHeightByReplyTweet:(Tweet *)replyTweet MaxHeightOfTextContent:(CGFloat)maxHeightOfTextContent;


@end

@protocol TweetCellDelegate <NSObject>

@optional
- (void)tweetCell:(TweetCell *)tweetCell didDeleteTweet:(Tweet *)tweet;
- (void)tweetCell:(TweetCell *)tweetCell didReplyTweet:(Tweet *)tweet;
- (void)tweetCell:(TweetCell *)tweetCell didLikeTweet:(Tweet *)tweet;

@end
