//
//  NSString+Common.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Common)

- (CGSize)calculateSize:(CGSize)size Font:(UIFont *)font;

/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

@end
