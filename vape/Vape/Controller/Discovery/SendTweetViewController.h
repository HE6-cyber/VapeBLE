//
//  SendTweetViewController.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BaseViewController.h"
#import "Tweet.h"


typedef NS_ENUM(NSInteger, SendType) {
    SendTypeBlog,   //发布新主题
    SendTypeComment //回复主题
};

@interface SendTweetViewController : BaseViewController

@property (assign, nonatomic) SendType  sendType;
@property (strong, nonatomic) Tweet     *currentRepliedTweet;

@property (copy, nonatomic) void(^didSendNewTweet)(Tweet *newTweet);

@property (copy, nonatomic) void(^didSendNewComment)(Tweet *newComment);

@end

