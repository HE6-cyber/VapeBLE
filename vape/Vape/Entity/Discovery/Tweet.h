//
//  Tweet.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger     kMaximum_Number_Of_Words;//发帖/跟帖的最大字数

@interface Tweet : NSObject

@property (assign, nonatomic) long long tweetId;

@property (assign, nonatomic) long long userId;
@property (strong, nonatomic) NSString  *userName;
@property (strong, nonatomic) NSString  *userIconUrl;
@property (strong, nonatomic) NSDate    *createTime;

@property (strong, nonatomic) NSString  *content;
@property (assign, nonatomic) NSInteger replyCount;

@property (strong, nonatomic) NSString  *photo1Url;
@property (strong, nonatomic) NSString  *photo2Url;
@property (strong, nonatomic) NSString  *photo3Url;
@property (strong, nonatomic) NSString  *photo4Url;
@property (strong, nonatomic) NSString  *photo5Url;
@property (strong, nonatomic) NSString  *photo6Url;
@property (strong, nonatomic) NSString  *photo7Url;
@property (strong, nonatomic) NSString  *photo8Url;
@property (strong, nonatomic) NSString  *photo9Url;


@property(assign, nonatomic) double     longitude;
@property(assign, nonatomic) double     latitude;
@property(strong, nonatomic) NSString   *address;

@property(assign, nonatomic) NSInteger  likeCount;
@property(assign, nonatomic) BOOL       isLike;

- (NSInteger)getPhotosCount;

- (NSArray *)getPhotoUrls;

- (void)setPhotoUrls:(NSArray *)photoUrls;

@end
