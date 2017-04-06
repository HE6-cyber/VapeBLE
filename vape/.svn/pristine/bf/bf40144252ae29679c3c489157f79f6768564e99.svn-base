//
//  RegisterCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "RegisterCommand.h"

@interface RegisterCommand () {
    NSString    *pPhone;
    NSString    *pPassword;
}

@end

@implementation RegisterCommand

- (instancetype)initRegisterCommandWithPhone:(NSString *)phone Password:(NSString *)password {
    if (self = [super init]) {
        opCode      = OperationCodeRegister;
        pPhone      = phone;
        pPassword   = password;
    }
    return self;
}

- (NSData *)getCommandData {
    
    RegisterRequestMessage *requestMsg = [RegisterRequestMessage new];
    requestMsg.phone    = pPhone;
    requestMsg.password = pPassword;
    requestMsg.phoneType= PhoneType_IPhone;
    messageData         = [requestMsg data];
    
    return [super getCommandData];
}

@end
