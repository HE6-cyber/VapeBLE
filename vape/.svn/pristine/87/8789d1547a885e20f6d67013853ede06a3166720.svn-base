//
//  CustomBundle.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "CustomBundle.h"
#import "LanguageHelper.h"

@implementation CustomBundle

/**
 * Method for retrieving localized strings.
 **/
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *languageBundle = [[LanguageHelper shareLanguageHelper] currentLanguageBundle];
    if (languageBundle != nil) {
        return [languageBundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end
