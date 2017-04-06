//
//  ResetPasswordCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "ResetPasswordCommand.h"

@interface ResetPasswordCommand () {
    NSString    *pPhone;
    NSString    *pPassword;
}

@end

@implementation ResetPasswordCommand

- (instancetype)initResetPasswordCommandWithPhone:(NSString *)phone Password:(NSString *)password {
    if (self = [super init]) {
        opCode      = OperationCodeResetPassword;
        pPhone      = phone;
        pPassword   = password;
    }
    return self;
}

- (NSData *)getCommandData {
    ResetPasswordRequestMessage *requestMsg = [ResetPasswordRequestMessage new];
    requestMsg.phone    = pPhone;
    requestMsg.password = pPassword;
    messageData         = [requestMsg data];
    return [super getCommandData];
}

@end
