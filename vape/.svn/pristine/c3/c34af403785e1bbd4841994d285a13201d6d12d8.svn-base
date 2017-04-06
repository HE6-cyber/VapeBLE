//
//  NSBundle+Custom.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "NSBundle+Custom.h"
#import <objc/runtime.h>
#import "CustomBundle.h"

@implementation NSBundle (Custom)

- (void)onLanguage {
    static dispatch_once_t  predicate;
    dispatch_once(&predicate, ^{
        object_setClass([NSBundle mainBundle], [CustomBundle class]);
    });
}


@end
