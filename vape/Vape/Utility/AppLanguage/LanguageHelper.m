//
//  Languager.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LanguageHelper.h"
#import "NSBundle+Custom.h"
#import "Utility.h"

#define kApple_Languages                        @"AppleLanguages"
#define kResource_File_Extension                @"lproj"

NSString *const  kLanguage_English              = @"en";
NSString *const  kLanguage_SimplifiedChinese    = @"zh-Hans";

static LanguageHelper *pLanguageHelper          = nil;
static NSString *pLanguageName                  = nil;
static NSBundle *pLanguageBundle                = nil;

@interface LanguageHelper ()


@end

@implementation LanguageHelper


//======================================================================================
#pragma mark - 单例
//======================================================================================
+ (LanguageHelper *)shareLanguageHelper {
    static dispatch_once_t  predicate;
    if (pLanguageHelper == nil) {
        dispatch_once(&predicate, ^{
            pLanguageHelper = [[LanguageHelper alloc] init];
        });
    }
    return pLanguageHelper;
}



//======================================================================================
#pragma mark - 语言名称
//======================================================================================
/**
 * 设置当前语言
 **/
- (void)setCurrentLanguageName:(NSString *)currentLanguageName {
    
    if ([currentLanguageName hasPrefix:kLanguage_SimplifiedChinese]) {
        currentLanguageName = kLanguage_SimplifiedChinese;
    }
    else if ([currentLanguageName hasPrefix:kLanguage_English]) {
        currentLanguageName = kLanguage_English;
    }
    
    if (currentLanguageName == nil || [currentLanguageName isEqualToString:@""] || [currentLanguageName isEqualToString:[self currentLanguageName]]) {
        return;
    }
    else {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:currentLanguageName ofType:kResource_File_Extension];
        if (resourcePath != nil && ![resourcePath isEqualToString:@""]) {
            NSBundle *languageBundle = [NSBundle bundleWithPath:resourcePath];
            if (languageBundle != nil) {
                pLanguageName   = currentLanguageName;
                pLanguageBundle = languageBundle;
            }
            else {
                pLanguageName   = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleDevelopmentRegionKey];
                pLanguageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:pLanguageName ofType:kResource_File_Extension]];
            }
        }
        else {
            pLanguageName   = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleDevelopmentRegionKey];
            pLanguageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:pLanguageName ofType:kResource_File_Extension]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@[pLanguageName] forKey:kApple_Languages];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSBundle mainBundle] onLanguage];
    }
}

/**
 * 获取当前语言的名称
 **/
- (NSString *)currentLanguageName {
    if (pLanguageName == nil || ![pLanguageName isEqualToString:@""]) {
        pLanguageName = [[[NSUserDefaults standardUserDefaults] objectForKey:kApple_Languages] objectAtIndex:0];
        if (pLanguageName == nil || [pLanguageName isEqualToString:@""]) {
            //如果不支持当前语言则加载info中Localization native development region中的值的lporj,设置为当前语言
            pLanguageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleDevelopmentRegionKey];
        }
    }
    
    if ([pLanguageName hasPrefix:kLanguage_SimplifiedChinese]) {
        pLanguageName = kLanguage_SimplifiedChinese;
    }
    else if ([pLanguageName hasPrefix:kLanguage_English]) {
        pLanguageName = kLanguage_English;
    }
    
    return pLanguageName;
}


//======================================================================================
#pragma mark - 语言资源
//======================================================================================
- (NSBundle *)currentLanguageBundle {
    if (pLanguageBundle == nil) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[self currentLanguageName] ofType:kResource_File_Extension];
        if (resourcePath != nil && ![resourcePath isEqualToString:@""]) {
            pLanguageBundle = [NSBundle bundleWithPath:resourcePath];
        }
        DebugLog(@"获取LanguageBundle");
    }
    return pLanguageBundle;
}


//======================================================================================
#pragma mark -
//======================================================================================
+ (UIStoryboard *)storyboardWithName:(NSString *)name {
    return [UIStoryboard storyboardWithName:name bundle:[[LanguageHelper shareLanguageHelper] currentLanguageBundle]];
}

- (UINib *)nibWithName:(NSString *)name {
    return [UINib nibWithNibName:name bundle:[self currentLanguageBundle]];
}

- (NSString *)stringWithKey:(NSString *)key {
    NSString *value = nil;
    if (key != nil && [self currentLanguageBundle] != nil) {
        value = [[self currentLanguageBundle] localizedStringForKey:key value:nil table:nil];
        value = (value!=nil?value:key);
    }
    return value;
}

- (UIImage *)image2xWithName:(NSString *)name {
    NSString *imagePath = [[self currentLanguageBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, @"@2x"] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (NSString *)localized:(NSString *)key {
    return [[LanguageHelper shareLanguageHelper] stringWithKey:key];
}

+ (UIImage *)localizedImage:(NSString *)name {
    return [[LanguageHelper shareLanguageHelper] image2xWithName:name];
}






@end
