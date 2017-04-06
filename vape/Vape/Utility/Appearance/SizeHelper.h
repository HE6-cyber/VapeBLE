//
//  SizeHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>


//======================================================================================================
#pragma mark - 屏幕尺寸
//======================================================================================================
#define kScreen_Size                [[UIScreen mainScreen] bounds].size
#define kScreen_Width               [[UIScreen mainScreen] bounds].size.width
#define kScreen_Height              [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds              [UIScreen mainScreen].bounds

#define kNavigationBar_Height       44
#define kStatusBar_Height           20

#define kContentInNavAndTab_Height  ([[UIScreen mainScreen] bounds].size.height - 64 - 49) //屏幕内容的高度(除去NavigationBar与Tabar高度)

#define kMargin_WH                  8 //一般边距的宽度


//======================================================================================================
#pragma mark - 根据屏幕尺寸获取当前iphone的屏幕版本
//======================================================================================================
#define kiPhone_3_5         35
#define kiPhone_4           40
#define kiPhone_4_7         47
#define kiPhone_5_5         55
#define kiPhone_Version     kScreen_Height>730?kiPhone_5_5:(kScreen_Height>660?kiPhone_4_7:(kScreen_Height>560?kiPhone_4:kiPhone_3_5))



//======================================================================================================
#pragma mark - iPhone手机软键盘尺寸
//======================================================================================================
#define kKeyboard_Normal_Height_iPhone              88
#define KEYBOARD_IPHONE56_NORMAL_HEIGHT             216
#define KEYBOARD_IPHONE6P_NORMAL_HEIGHT             226
#define KEYBOARD_IPHONE5_MAX_HEIGHT                 253
#define KEYBOARD_IPHONE6_MAX_HEIGHT                 258
#define KEYBOARD_IPHONE6P_MAX_HEIGHT                271
#define KEYBOARD_CURRENT_MAX_HEIGHT                 (IPHONE_VERSION==IPHONE6P?KEYBOARD_IPHONE6P_MAX_HEIGHT:(IPHONE_VERSION==IPHONE6?KEYBOARD_IPHONE6_MAX_HEIGHT:KEYBOARD_IPHONE5_MAX_HEIGHT))


//======================================================================================================
#pragma mark - 边框线宽度和高度
//======================================================================================================
#define kBorder_Line_WH                             0.5f    //边框线宽度/高度




//======================================================================================================
#pragma mark - 左侧栏菜单宽度
//======================================================================================================
#define kLeftMenu_Width                         (kScreen_Width * 0.7)


//======================================================================================================
#pragma mark - 边框线宽度和高度
//======================================================================================================
#define kBorder_Line_Width                           0.5f    //边框线宽度
#define kBorder_Line_Height                          0.5f    //边框线高度
#define kBorder_Line_WH                              0.5f    //边框线高度


#define  kBackButtonFontSize 16


