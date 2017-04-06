//
//  OperationCommand.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#import "CommonResponse.pbobjc.h"
#import "ErrorMessageResponse.pbobjc.h"
#import "PhoneType.pbobjc.h"

#import "RegisterRequest.pbobjc.h"
#import "RegisterResponse.pbobjc.h"
#import "LoginRequest.pbobjc.h"
#import "LoginResponse.pbobjc.h"

#import "UpdatePasswordRequest.pbobjc.h"
#import "ResetPasswordRequest.pbobjc.h"
#import "UpdateProfileRequest.pbobjc.h"
#import "UpdateProfileResponse.pbobjc.h"

#import "SmokingData.pbobjc.h"
#import "SmokingLocationData.pbobjc.h"
#import "UploadFailData.pbobjc.h"

#import "UploadSmokingDataRequest.pbobjc.h"
#import "UploadSmokingDataResponse.pbobjc.h"
#import "DownloadSmokingDataRequest.pbobjc.h"
#import "DownloadSmokingDataResponse.pbobjc.h"

#import "UploadSmokingLocationDataRequest.pbobjc.h"
#import "UploadSmokingLocationDataResponse.pbobjc.h"
#import "DownloadSmokingLocationDataRequest.pbobjc.h"
#import "DownloadSmokingLocationDataResponse.pbobjc.h"

#import "HeartRateData.pbobjc.h"
#import "UploadHeartRateDataRequest.pbobjc.h"
#import "UploadHeartRateDataResponse.pbobjc.h"
#import "DownloadHeartRateDataRequest.pbobjc.h"
#import "DownloadHeartRateDataResponse.pbobjc.h"

#import "GetBlogListRequest.pbobjc.h"
#import "GetBlogListResponse.pbobjc.h"

#import "GetCommentListRequest.pbobjc.h"
#import "GetCommentListResponse.pbobjc.h"

#import "GetLikeListRequest.pbobjc.h"
#import "GetLikeListResponse.pbobjc.h"

//=============================================================================
/// 消息头部相关的常量
//=============================================================================
extern const int START_CODE;                  //消息开始码
extern const int DATA_SIZE_VALUE_LENGTH;      //消息中表示消息尺寸值的长度
extern const int START_CODE_LENGTH;           //消息开始码长度
extern const int OPERATION_CODE_LENGTH;       //消息操作码长度


//=============================================================================
/// Operation Code
//=============================================================================
typedef enum {

    OperationCodeRegister                       = 0x00001001,       //用户注册
    OperationCodeLogin                          = 0x00001002,       //用户登录
    
    OperationCodeUpdatePassword                 = 0x00001003,       //修改密码
    OperationCodeResetPassword                  = 0x00001004,       //重置密码
    OperationCodeUpdateProfile                  = 0x00001005,       //修改用户个人信息
    
    OperationCodeUploadSmokingData              = 0x00002001,       //上传吸烟数据，用户点击上传按钮触发
    OperationCodeDownloadSmokingData            = 0x00002002,       //下载吸烟数据，登录时触发，APP端记录最后更新时间
    
    OperationCodeUploadSmokingLocationData      = 0x00002003,       //上传吸烟地址数据
    OperationCodeDownloadSmokingLocationData    = 0x00002004,       //下载吸烟地址数据
    
    OperationCodeUploadHeartRateData            = 0x00002005,       //上传心率血氧数据
    OperationCodeDownloadHeartRateData          = 0x00002006,       //下载心率血氧数据
    
    OperationCodeGetBlogList                    = 0x00003003,       //分页加载主题列表
    OperationCodeGetCommentList                 = 0x00003004,       //分页加载跟帖
    OperationCodeGetLikeList                    = 0x00003008        //分页加载点赞列表
    
} OperationCode;




@interface OperationCommand : NSObject  {
    
@protected
    OperationCode   opCode;
    NSData          *messageData;
    
}


///返回命令所发送的字节码：消息长度值 = 开始码(4byte) + 长度(4byte) + 操作码(4byte)
- (NSData *)getCommandData;

///返回命令的操作码
- (OperationCode)getOperationCode;

///判断指定的数值是否是正确的操作码
+ (BOOL)isOperationCode:(NSInteger)codeValue;

@end
