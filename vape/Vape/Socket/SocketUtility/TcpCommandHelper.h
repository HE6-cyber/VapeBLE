//
//  TcpCommandHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationCommand.h"
#import "RegisterCommand.h"
#import "LoginCommand.h"
#import "UpdatePasswordCommand.h"
#import "ResetPasswordCommand.h"
#import "UpdateProfileCommand.h"

#import "UploadSmokingDataCommand.h"
#import "DownloadSmokingDataCommand.h"
#import "UploadSmokingLocationDataCommand.h"
#import "DownloadSmokingLocationDataCommand.h"
#import "UploadHeartRateDataCommand.h"
#import "DownloadHeartRateDataCommand.h"

#import "GetBlogListCommand.h"
#import "GetCommentListCommand.h"
#import "GetLikeListCommand.h"


//===================================服务器地址与端口========================================
extern NSString *const    SERVER_IP;      //服务器IP
extern const    int       SERVER_PORT;    //服务器端口
//========================================================================================


#define TcpCommandHelperDidReceiveSessionHasExpiredNotification     @"TcpCommandHelperDidReceiveSessionHasExpiredNotification" //会话过期通知


//=====================================Error Code=========================================
typedef NS_ENUM(NSInteger, ReturnErrorCode) {
    ReturnErrorCodeSuccess                  =   0,      //成功
    ReturnErrorCodeConnectTimeOut           =   3,      //Attempt to connect to host timed out
    ReturnErrorCodeWriteOperationTimeOut    =   5,      //Write operation timed out
    ReturnErrorCodeSocketClosedByRemotePeer =   7,
    ReturnErrorCodeNetworkUnreachable       =   51,     //网络不可达
    ReturnErrorCodeSocketNotConnected       =   57,     //Socket is not connected
    ReturnErrorCodeConnectionRefused        =   61,
    ReturnErrorCodeUnknown                  =   10000,  //未知错误
    ReturnErrorCodeUserDataError            =   88888,  //从服务器返回的数据解析时出现错误
    ReturnErrorCodeSessionExpired           =   10007,  //会话超时,需重新登录
    ReturnErrorCodeNotNetwork               =   99999   //没有网络(使用AFNetworking检测网络连通性时，不可达即返回该错误)
};
//========================================================================================


@protocol TcpCommandHelperDelegate <NSObject>

@required
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode;
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode;

@end


@interface TcpCommandHelper : NSObject

@property (weak, nonatomic) id<TcpCommandHelperDelegate>      delegate;

///获取公用的实例对象
+ (TcpCommandHelper *)shareTcpCommandHelperWithDelegate:(id<TcpCommandHelperDelegate>)delegate;

///获取一个新的实例对象
+ (TcpCommandHelper *)tcpCommandHelperWithDelegate:(id<TcpCommandHelperDelegate>)delegate;

- (void)sendCommand:(OperationCommand *)operationCommand;
- (void)sendCommandWithNoCheckNetworkStatus:(OperationCommand *)operationCommand;

//关闭Socket连接
- (void)disConnect;

@end
