//
//  ShareContent.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface ShareContent : NSObject

@property (strong, nonatomic)   NSString    *title;
@property (strong, nonatomic)   NSString    *content;
@property (strong, nonatomic)   UIImage     *image;

@end
