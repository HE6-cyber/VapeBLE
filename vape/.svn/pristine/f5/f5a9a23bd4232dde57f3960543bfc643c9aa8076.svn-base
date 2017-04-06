//
//  Languager.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const  kLanguage_English;
extern NSString *const  kLanguage_SimplifiedChinese;

@interface LanguageHelper : NSObject

//======================================================================================
#pragma mark - 单例
//======================================================================================
+ (LanguageHelper *)shareLanguageHelper;

//======================================================================================
#pragma mark - 设置语言名称、获取语言名称、获取语言资源包
//======================================================================================
- (void)setCurrentLanguageName:(NSString *)currentLanguageName;
- (NSString *)currentLanguageName;
- (NSBundle *)currentLanguageBundle;

+ (UIStoryboard *)storyboardWithName:(NSString *)name;

@end
