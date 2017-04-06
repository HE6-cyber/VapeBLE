//
//  ReplyTweetCell.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEdge_Width                 8   //边缘的分隔区域宽度
#define kPhoto_WH                   ((kScreen_Width - 72)/9)

@class Tweet;

@protocol MReplyTweetCellDelegate;

@interface MReplyTweetCell : UITableViewCell {
    
}

@property (strong, nonatomic) UILabel   *topLine;
@property (strong, nonatomic) UILabel   *bottomLine;

@property (weak, nonatomic) id<MReplyTweetCellDelegate> delegate;

- (void)setCurrentTweet:(Tweet *)tweet;

/** 计算单元格的内容视图高度 */
+ (CGFloat)calculateContentViewHeightByReplyTweet:(Tweet *)replyTweet;

@end



@protocol MReplyTweetCellDelegate <NSObject>

@optional
- (void)replyTweetCell:(MReplyTweetCell *)tweetCell didDeleteTweet:(Tweet *)tweet;

@end
