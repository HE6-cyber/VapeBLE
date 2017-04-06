//
//  LikeInfo.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikeInfo : NSObject

@property (assign, nonatomic) long long userId;
@property (strong, nonatomic) NSString  *author;
@property (strong, nonatomic) NSString  *authorPhotoUrl;
@property (strong, nonatomic) NSDate    *createDt;

@end
