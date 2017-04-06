//
//  DetailTweetViewController.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BaseViewController.h"

@class Tweet;

@interface DetailTweetViewController : BaseViewController

@property (strong, nonatomic) Tweet *currentTweet;

@property (copy, nonatomic) void(^didReply)(Tweet *tweet);
@property (copy, nonatomic) void(^didDeleteBlog)(Tweet *tweet);
@property (copy, nonatomic) void(^didDeleteComment)(Tweet *tweet);
@property (copy, nonatomic) void(^didLikeBlog)(Tweet *tweet);

@end
