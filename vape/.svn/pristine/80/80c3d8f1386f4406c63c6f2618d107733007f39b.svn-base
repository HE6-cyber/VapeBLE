//
//  validation.h
//  ValidateIt
//
//  Created by Arpi Dermardirousian on 1/27/14.
//  Copyright (c) 2014 Arpi Dermardirousian. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CValidator : NSObject


//============================================================================================
#pragma mark - 邮箱地址、手机号码、固话号码、身份证号码
//============================================================================================
///使用正则表达式验证邮箱的格式
-(void)validateEmailAddress:(NSString*)emailAddress FieldName:(NSString *)fieldName;

///使用正则表达式验证手机号码的格式
-(void)validateCellphoneNo:(NSString*)cellphoneNo FieldName:(NSString*)fieldName;

///使用正则表达式验证固定电话号码的格式
-(void)validateTelephoneNo:(NSString*)telephoneNo FieldName:(NSString *)fieldName;

///使用正则表达式验证身份证号码的格式
-(void)validateIDCardNo:(NSString*)idCardNo FieldName:(NSString*)fieldName;


//============================================================================================
#pragma mark - 字符串特征验证（空、长度、相等）
//============================================================================================
///验证字段的值不能是否空（字符串类型的值））
-(void)validateRequired:(NSString*)text FieldName:(NSString*)fieldName;

///验证字段的值是否不小于指定的最小长度（字符串类型的值）
-(void)validateMinLength:(NSInteger)minLength  Text:(NSString*)text FieldName:(NSString*)fieldName;

///验证字段的值是否不大于指定的最大长度（字符串类型的值）
-(void)validateMaxLength:(NSInteger)maxLength Text:(NSString*)text FieldName:(NSString*)fieldName;

///验证字段的值是否不小于指定的最小长度并且不大于指定的最大长度（字符串类型的值）
-(void)validateMinLength:(NSInteger)minLength MaxLength:(NSInteger)maxLength Text:(NSString*)text FieldName:(NSString*)fieldName;

///验证两个字段的值是否相等（字符串类型的值）
-(void)validateEqual:(NSString*)firstText FirstFieldName:(NSString*)firstFieldName SecondText:(NSString*)secondText SecondFieldName:(NSString*)secondFieldName;

///验证两个字段的值是否不相等（字符串类型的值）
-(void)validateNotEqual:(NSString*)firstText FirstFieldName:(NSString*)firstFieldName SecondText:(NSString*)secondText SecondFieldName:(NSString*)secondFieldName;


//============================================================================================
#pragma mark - 字符串特征验证（字母和空格、字母和数字、符合正则表达式）
//============================================================================================
///使用正则表达式验证字段的值是否仅包含字母和空格（字符串类型的值）
-(void)validateLetterSpaceOnly:(NSString*)text FieldName:(NSString*)fieldName;

///使用正则表达式验证字段的值是否仅包含字母和数字（字符串类型的值）
-(void)validateAlphaNumber:(NSString*)text FieldName:(NSString*)fieldName;

///验证字段的值是否匹配指定的正则表达式（字符串类型的值）
-(void)validateText:(NSString*)text RegExpress:(NSString*)regExpress FieldName:(NSString*)fieldName;



//============================================================================================
#pragma mark - 
//============================================================================================
///验证字段的值是否符合数值型字面量的格式（字符串类型的值）
-(void)validateNumeric:(NSString*)text FieldName:(NSString*)fieldName;

///验证字段的值是否符合数值型字面量的格式;将该值转化成数值后，是否不小于指定的最小值并且不大于指定的最大值（字符串类型的值）
-(void)validateNumericInRange:(NSString*)text FieldName:(NSString*)fieldName MaxValue:(double)maxValue MinValue:(double)minValue;

///验证字段的值是否符合整数字面量的格式（字符串类型的值）
-(void)validateInteger:(NSString*)text FieldName:(NSString*)fieldName;

///验证字段的值是否符合整数字面量的格式;将该值转化成整数后，是否不小于指定的最小值并且不大于指定的最大值（字符串类型的值）
-(void)validateIntegerInRange:(NSString*)text FieldName:(NSString*)fieldName MaxValue:(NSInteger)maxValue MinValue:(NSInteger)minValue;




//============================================================================================
#pragma mark -
//============================================================================================
-(BOOL)isValid;

-(NSArray*)errorMsgs;



@end
