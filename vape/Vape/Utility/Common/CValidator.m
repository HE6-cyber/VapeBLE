//
//  validation.m
//  ValidateIt
//
//  Created by Arpi Dermardirousian on 1/27/14.
//  Copyright (c) 2014 Arpi Dermardirousian. All rights reserved.
//

#import "CValidator.h"
#import "StringHelper.h"

static const NSInteger  kSuccess_Flag   = 0;
static const NSInteger  kError_Flag     = 1;


@interface CValidator ()  {
    
    NSMutableArray          *errors;
    NSMutableArray          *errorMsgs;

    NSMutableArray          *emailAddressErrorMsg;
    NSMutableArray          *cellphoneNoErrorMsg;
    NSMutableArray          *telephoneNoErrorMsg;
    NSMutableArray          *idCardNoErrorMsg;
    
    NSMutableArray          *requiredErrorMsg;
    NSMutableArray          *minLengthErrorMsg;
    NSMutableArray          *maxLengthErrorMsg;
    NSMutableArray          *equalErrorMsg;
    NSMutableArray          *notEqualErrorMsg;
    
    NSMutableArray          *letterSpaceOnlyErrorMsg;
    NSMutableArray          *alphaNumberErrorMsg;
    NSMutableArray          *regexErrorMsg;
    
    NSMutableArray          *numericErrorMsg;
    NSMutableArray          *numericInRangeErrorMsg;
    NSMutableArray          *integerErrorMsg;
    NSMutableArray          *integerInRangeErrorMsg;
    
    NSMutableArray          *minAndMaxLengthErrorMsg;
    
}


@end

@implementation CValidator

//===============================================================================
#pragma mark - 初始化方法
//===============================================================================
- (id)init {
    self = [super init];
    if (self) {
        
        errors = [NSMutableArray arrayWithObjects:
                  @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag),
                  @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag),
                  @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag), @(kSuccess_Flag),
                  @(kSuccess_Flag), @(kSuccess_Flag), nil];
        errorMsgs               = [NSMutableArray new];

        emailAddressErrorMsg    = [NSMutableArray new];
        cellphoneNoErrorMsg     = [NSMutableArray new];
        telephoneNoErrorMsg     = [NSMutableArray new];
        idCardNoErrorMsg        = [NSMutableArray new];
        
        requiredErrorMsg        = [NSMutableArray new];
        minLengthErrorMsg       = [NSMutableArray new];
        maxLengthErrorMsg       = [NSMutableArray new];
        equalErrorMsg           = [NSMutableArray new];
        notEqualErrorMsg        = [NSMutableArray new];
        
        letterSpaceOnlyErrorMsg = [NSMutableArray new];
        alphaNumberErrorMsg     = [NSMutableArray new];
        regexErrorMsg           = [NSMutableArray new];
        
        numericErrorMsg         = [NSMutableArray new];
        numericInRangeErrorMsg  = [NSMutableArray new];
        integerErrorMsg         = [NSMutableArray new];
        integerInRangeErrorMsg  = [NSMutableArray new];
        
        minAndMaxLengthErrorMsg = [NSMutableArray new];
        
    }
    return self;
}

///获取与目的字符串中与源字符串匹配的子串的location
-(NSInteger)indexOfString:(NSString*)string subString:(NSString*)subString {
    
    if (subString==nil) {  return -1; }
    
    NSRange range = [string rangeOfString:subString];
    if (range.length > 0){
        return range.location;
    }
    else{ /*{NSNotFound,0}*/
        return -1;
    }
    
}

//============================================================================================
#pragma mark - 邮箱地址、手机号码、固话号码、身份证号码
//============================================================================================
///使用正则表达式验证邮箱的格式
-(void)validateEmailAddress:(NSString*)emailAddress FieldName:(NSString *)fieldName {
    
    if(emailAddress.length > 0) {
        NSString *emailAddressRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailAddressRegex];
        NSString *msg = [NSString stringWithFormat:@"%@格式不正确.", fieldName];
    
        if ([predicate evaluateWithObject:[emailAddress lowercaseString]] == NO) {
            [emailAddressErrorMsg addObject:msg];
        }
    }
    
}

///使用正则表达式验证手机号码的格式
-(void)validateCellphoneNo:(NSString*)cellphoneNo FieldName:(NSString*)fieldName {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString *cellphoneNoRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cellphoneNoRegex];
    NSString *msg = [NSString stringWithFormat:@"%@格式不正确.", fieldName];
        
    if ([predicate evaluateWithObject:cellphoneNo] == NO) {
        [cellphoneNoErrorMsg addObject:msg];
    }
}

///使用正则表达式验证固定电话号码的格式
-(void)validateTelephoneNo:(NSString*)telephoneNo FieldName:(NSString *)fieldName {
    if(telephoneNo.length > 0){
        NSString *telephoneNoRegex = @"^0(10|2[0-5789]\\d{3})-\\d{7,8}(-\\d{1,4})?$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telephoneNoRegex];
        NSString *msg = @"不正确！";
        
        if ([predicate evaluateWithObject:telephoneNo] == NO) {
            [telephoneNoErrorMsg addObject:msg];
        }
    }
}


///使用正则表达式验证身份证号码的格式
-(void)validateIDCardNo:(NSString*)idCardNo FieldName:(NSString*)fieldName {
    if(idCardNo.length > 0){
        NSString *idCardNoRegex = @"^(\\d{14}|\\d{17})(\\d|x|X)$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardNoRegex];
        NSString *msg = @"IDCard Number is invalid.";

        if ([predicate evaluateWithObject:idCardNo] == NO) {
            [idCardNoErrorMsg addObject:msg];
        }
    }
    
}




//============================================================================================
#pragma mark - 字符串特征验证（空、长度、相等）
//============================================================================================
///验证字段的值不能是否空（字符串类型的值）
-(void)validateRequired:(NSString*)text FieldName:(NSString*)fieldName {
    
    if ([text isEqualToString:@""]) {
        NSString *msg = [NSString stringWithFormat:@"%@",fieldName];
        [requiredErrorMsg addObject:msg];
    }
}


///验证字段的值是否不小于指定的最小长度（字符串类型的值）
-(void)validateMinLength:(NSInteger)minLength  Text:(NSString*)text FieldName:(NSString*)fieldName {
    
    if(text.length < minLength){
        NSString *msg = [NSString stringWithFormat:@"%@不能小于%li个字符.",fieldName, (long)minLength];
        [minLengthErrorMsg addObject:msg];
    }
}

///验证字段的值是否不大于指定的最大长度（字符串类型的值）
-(void)validateMaxLength:(NSInteger)maxLength Text:(NSString*)text FieldName:(NSString*)fieldName {
    
    if(text.length > maxLength) {
        NSString *msg = [NSString stringWithFormat:@"%@不能大于%li个字符.",fieldName, (long)maxLength];
        [maxLengthErrorMsg addObject:msg];
    }
}

//////验证字段的值是否不小于指定的最小长度并且不大于指定的最大长度（字符串类型的值）
- (void)validateMinLength:(NSInteger)minLength MaxLength:(NSInteger)maxLength Text:(NSString *)text FieldName:(NSString *)fieldName {
    if (text.length < minLength || text.length > maxLength) {
        NSString *msg = [NSString stringWithFormat:@"%@的长度必须是%ld-%ld个字符." ,fieldName, (long)minLength, (long)maxLength];
        [minAndMaxLengthErrorMsg addObject:msg];
    }
}


///验证两个字段的值是否相等（字符串类型的值）
-(void)validateEqual:(NSString*)firstText FirstFieldName:(NSString*)firstFieldName SecondText:(NSString*)secondText SecondFieldName:(NSString*)secondFieldName {

    if([firstText isEqualToString:secondText]==NO) {
        NSString *msg = [NSString stringWithFormat:@"%@与%@不一致.", firstFieldName, secondFieldName];//
        [equalErrorMsg addObject:msg];
    }
}


///验证两个字段的值是否不相等（字符串类型的值）
-(void)validateNotEqual:(NSString*)firstText FirstFieldName:(NSString*)firstFieldName SecondText:(NSString*)secondText SecondFieldName:(NSString*)secondFieldName {
    
    if([firstText isEqualToString:secondText] == YES) {
        NSString *msg = [NSString stringWithFormat:@"您输入的%@和%@一样,请查证.",firstFieldName, secondFieldName];
        [notEqualErrorMsg addObject:msg];
    }
}



//============================================================================================
#pragma mark -
//============================================================================================
///使用正则表达式验证字段的值是否仅包含字母和空格（字符串类型的值）
-(void)validateLetterSpaceOnly:(NSString*)text FieldName:(NSString*)fieldName {
    
    NSString *letterSpaceRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", letterSpaceRegex];
    if(text.length > 0){
        if([predicate evaluateWithObject:text] == NO){
            NSString *msg = [NSString stringWithFormat:@"%@%s",fieldName," should contain letters and space only."];
            [letterSpaceOnlyErrorMsg addObject:msg];
        }
    }
}

///使用正则表达式验证字段的值是否仅包含字母和数字（字符串类型的值）
-(void)validateAlphaNumber:(NSString*)text FieldName:(NSString*)fieldName {
    
    NSString *alphaNumberRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNumberRegex];
    if(text.length > 0){
        if([predicate evaluateWithObject:text] == NO){
            NSString *msg = [NSString stringWithFormat:@"%@只能包含字符和数字.",fieldName];
            [alphaNumberErrorMsg addObject:msg];
        }
    }
}

///验证字段的值是否匹配指定的正则表达式（字符串类型的值）
-(void)validateText:(NSString*)text RegExpress:(NSString*)regExpress FieldName:(NSString*)fieldName {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExpress];
    if(text.length > 0){
        if([predicate evaluateWithObject:text] == NO){
            NSString *msg = [NSString stringWithFormat:@"%@没有匹配%@", fieldName, regExpress];
            [regexErrorMsg addObject:msg];
        }
    }
}




//============================================================================================
#pragma mark -
//============================================================================================
///验证字段的值是否符合数值型字面量的格式（字符串类型的值）
-(void)validateNumeric:(NSString*)text FieldName:(NSString*)fieldName {
    
    NSString *numericRegex = @"^(-?\\d+)(\\.\\d+)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    if(text.length > 0){
        if([predicate evaluateWithObject:text] == NO){
            NSString *msg = [NSString stringWithFormat:@"%@必须是数值.",fieldName];
            [numericErrorMsg addObject:msg];
        }
    }
}

///验证字段的值是否符合数值型字面量的格式;将该值转化成数值后，是否不小于指定的最小值并且不大于指定的最大值（字符串类型的值）
-(void)validateNumericInRange:(NSString*)text FieldName:(NSString*)fieldName MaxValue:(double)maxValue MinValue:(double)minValue {
    
    NSString *numericRegex = @"^(-?\\d+)(\\.\\d+)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    if(text.length > 0){
        if([predicate evaluateWithObject:text] == NO) {
            NSString *msg = [NSString stringWithFormat:@"%@必须是数值.",fieldName];
            [numericInRangeErrorMsg addObject:msg];
            return;
        }
        else if ([text doubleValue] < minValue) {
            NSString *msg = [NSString stringWithFormat:@"%@不能小于:%f.", fieldName, minValue];
            [numericInRangeErrorMsg addObject:msg];
            return;
        }
        else if ([text doubleValue] > maxValue) {
            NSString *msg = [NSString stringWithFormat:@"%@不能大于:%f.", fieldName, maxValue];
            [numericInRangeErrorMsg addObject:msg];
            return;
        }
    }
}


///验证字段的值是否符合整数字面量的格式（字符串类型的值）
-(void)validateInteger:(NSString*)text FieldName:(NSString*)fieldName {
    
    NSString *integerRegex = @"^-?\\d+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", integerRegex];
    if(text.length > 0){
        if([predicate evaluateWithObject:text] == NO){
            NSString *msg = [NSString stringWithFormat:@"%@必须为数字",fieldName];
            [integerErrorMsg addObject:msg];
        }
    }
}

///验证字段的值是否符合整数字面量的格式;将该值转化成整数后，是否不小于指定的最小值并且不大于指定的最大值（字符串类型的值）
-(void)validateIntegerInRange:(NSString*)text FieldName:(NSString*)fieldName MaxValue:(NSInteger)maxValue MinValue:(NSInteger)minValue {
 
    NSString *integerRegex = @"^-?\\d+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", integerRegex];
    if(text.length > 0) {
        if([predicate evaluateWithObject:text] == NO) {
            NSString *msg = [NSString stringWithFormat:@"%@ must be an integer", fieldName];
            [integerInRangeErrorMsg addObject:msg];
            return;
        }
        else if([text integerValue] < minValue) {
            NSString *msg = [NSString stringWithFormat:@"%@ not less than %ld", fieldName,(long)minValue];
            [integerInRangeErrorMsg addObject:msg];
            return;
        }
        else if([text integerValue] > maxValue) {
            NSString *msg = [NSString stringWithFormat:@"%@ no more than %ld", fieldName,(long)maxValue];
            [integerInRangeErrorMsg addObject:msg];
            return;
        }
    }
}







//============================================================================================
#pragma mark - 检查整个验证对象
//============================================================================================
-(BOOL)isValid {
    
    //邮箱地址
    if(emailAddressErrorMsg.count > 0){
        [errors replaceObjectAtIndex:0 withObject:@(kError_Flag)];
        for(NSString *msg in emailAddressErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
  
    //手机号码
    if(cellphoneNoErrorMsg.count > 0){
        [errors replaceObjectAtIndex:1 withObject:@(kError_Flag)];
        for(NSString *msg in cellphoneNoErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    //固定电话号码
    if(telephoneNoErrorMsg.count > 0){
        [errors replaceObjectAtIndex:2 withObject:@(kError_Flag)];
        for(NSString *msg in telephoneNoErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    //身份证号码
    if(idCardNoErrorMsg.count > 0){
        [errors replaceObjectAtIndex:3 withObject:@(kError_Flag)];
        for(NSString *msg in idCardNoErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    
    //======================================================================================//
    

    //不能为空
    if(requiredErrorMsg.count > 0){
        [errors replaceObjectAtIndex:4 withObject:@(kError_Flag)];
        NSMutableString *msgString = [NSMutableString new];
        for(NSString *msg in requiredErrorMsg){
            [msgString appendFormat:@"%@、",[msg lowercaseString]];
        }
        [msgString deleteCharactersInRange:NSMakeRange([msgString length]-1, 1)];
        [msgString replaceCharactersInRange:NSMakeRange(0, 1) withString:[[msgString substringWithRange:NSMakeRange(0, 1)] uppercaseString]];
        [errorMsgs addObject:[NSString stringWithFormat:@"%@不能为空.", msgString]];
    }
    
    //不能小于最小长度
    if(minLengthErrorMsg.count > 0){
        [errors replaceObjectAtIndex:5 withObject:@(kError_Flag)];
        for(NSString *msg in minLengthErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    //不能大于最大长度
    if(maxLengthErrorMsg.count > 0){
        [errors replaceObjectAtIndex:6 withObject:@(kError_Flag)];
        for(NSString *msg in maxLengthErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    //等于
    if(equalErrorMsg.count > 0){
        [errors replaceObjectAtIndex:7 withObject:@(kError_Flag)];
        for(NSString *msg in equalErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    //不等于
    if(notEqualErrorMsg.count > 0){
        [errors replaceObjectAtIndex:8 withObject:@(kError_Flag)];
        for(NSString *msg in notEqualErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
 
    
    //======================================================================================//
    
    //仅包含字母和空格
    if(letterSpaceOnlyErrorMsg.count > 0 ){
        [errors replaceObjectAtIndex:9 withObject:@(kError_Flag)];
        for (NSString *msg in  letterSpaceOnlyErrorMsg) {
            [errorMsgs addObject:msg];
        }
    }

    //仅包含字母和数字
    if(alphaNumberErrorMsg.count > 0){
        [errors replaceObjectAtIndex:10 withObject:@(kError_Flag)];
        for(NSString *msg in alphaNumberErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
    
    //符合正则表达式
    if(regexErrorMsg.count > 0){
        [errors replaceObjectAtIndex:11 withObject:@(kError_Flag)];
        for(NSString *msg in regexErrorMsg){
            [errorMsgs addObject:msg];
        }
    }

   
    //======================================================================================//
    
    //符合数值型字面量格式
    if(numericErrorMsg.count > 0){
        [errors replaceObjectAtIndex:12 withObject:@(kError_Flag)];
        for(NSString *msg in numericErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
  
    //符合数值型字面量格式，并且转换后的数值位于指定闭区间
    if(numericInRangeErrorMsg.count > 0){
        [errors replaceObjectAtIndex:13 withObject:@(kError_Flag)];
        for(NSString *msg in numericInRangeErrorMsg){
            [errorMsgs addObject:msg];
        }
    }
 
    //符合整型字面量格式
   if(integerErrorMsg.count > 0){
       [errors replaceObjectAtIndex:14 withObject:@(kError_Flag)];
       for(NSString *msg in integerErrorMsg){
           [errorMsgs addObject:msg];
       }
    }
   
    //符合整型字面量格式，并且转换后的整数位于指定闭区间
    if(integerInRangeErrorMsg.count > 0){
        [errors replaceObjectAtIndex:15 withObject:@(kError_Flag)];
        for(NSString *msg in integerInRangeErrorMsg){
            [errorMsgs addObject:msg];
            
        }
    }
    
    //字符串长度不能小于指定最小长度而且不能大于指定的最大长度
    if(minAndMaxLengthErrorMsg.count > 0){
        [errors replaceObjectAtIndex:16 withObject:@(kError_Flag)];
        for(NSString *msg in minAndMaxLengthErrorMsg){
            [errorMsgs addObject:msg];
            
        }
    }
    
    for (NSNumber *obj in errors) {
        if ([obj integerValue] == kError_Flag) {
            return NO;
        }
    }
    return YES;
}

-(NSArray *)errorMsgs {
    return errorMsgs;
}

@end
