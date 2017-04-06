//
//  Tweet.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "Tweet.h"

const NSInteger     kMaximum_Number_Of_Words    = 500;//发帖/跟帖的最大字数

@implementation Tweet

- (NSInteger)getPhotosCount {
    NSInteger photosCount = 0;
    if (self != nil) {
        if (self.photo1Url != nil && ![self.photo1Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo2Url != nil && ![self.photo2Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo3Url != nil && ![self.photo3Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo4Url != nil && ![self.photo4Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo5Url != nil && ![self.photo5Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo6Url != nil && ![self.photo6Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo7Url != nil && ![self.photo7Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo8Url != nil && ![self.photo8Url isEqualToString:@""]) {
            photosCount++;
        }
        if (self.photo9Url != nil && ![self.photo9Url isEqualToString:@""]) {
            photosCount++;
        }
    }
    return photosCount;
}

- (NSArray *)getPhotoUrls {
    NSMutableArray *photoUrls = [NSMutableArray new];
    if (self != nil) {
        if (self.photo1Url != nil && ![self.photo1Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo1Url];
        }
        if (self.photo2Url != nil && ![self.photo2Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo2Url];
        }
        if (self.photo3Url != nil && ![self.photo3Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo3Url];
        }
        if (self.photo4Url != nil && ![self.photo4Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo4Url];
        }
        if (self.photo5Url != nil && ![self.photo5Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo5Url];
        }
        if (self.photo6Url != nil && ![self.photo6Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo6Url];
        }
        if (self.photo7Url != nil && ![self.photo7Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo7Url];
        }
        if (self.photo8Url != nil && ![self.photo8Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo8Url];
        }
        if (self.photo9Url != nil && ![self.photo9Url isEqualToString:@""]) {
            [photoUrls addObject:self.photo9Url];
        }
    }
    return photoUrls;
}

- (void)setPhotoUrls:(NSArray *)photoUrls {
    if (self != nil && photoUrls != nil) {
        self.photo1Url = photoUrls.count>0 ? photoUrls[0] : nil;
        self.photo2Url = photoUrls.count>1 ? photoUrls[1] : nil;
        self.photo3Url = photoUrls.count>2 ? photoUrls[2] : nil;
        self.photo4Url = photoUrls.count>3 ? photoUrls[3] : nil;
        self.photo5Url = photoUrls.count>4 ? photoUrls[4] : nil;
        self.photo6Url = photoUrls.count>5 ? photoUrls[5] : nil;
        self.photo7Url = photoUrls.count>6 ? photoUrls[6] : nil;
        self.photo8Url = photoUrls.count>7 ? photoUrls[7] : nil;
        self.photo9Url = photoUrls.count>8 ? photoUrls[8] : nil;
    }
}



@end
