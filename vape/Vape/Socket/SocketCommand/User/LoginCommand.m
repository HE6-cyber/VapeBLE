//
//  LoginCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LoginCommand.h"


@interface LoginCommand () {
    NSString    *pPhone;
    NSString    *pPassword;
}

@end

@implementation LoginCommand

- (instancetype)initLoginCommandWithPhone:(NSString *)phone Password:(NSString *)password {
    if (self = [super init]) {
        opCode      = OperationCodeLogin;
        pPhone      = phone;
        pPassword   = password;
    }
    return self;
}

- (NSData *)getCommandData {
    
    LoginRequestMessage *requestMsg = [LoginRequestMessage new];
    requestMsg.phone        = pPhone;
    requestMsg.password     = pPassword;
    requestMsg.phoneType    = PhoneType_IPhone;
    messageData             = [requestMsg data];
    
    return [super getCommandData];
}

@end
