//
//  UpdatePasswordCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UpdatePasswordCommand.h"

@interface UpdatePasswordCommand () {
    NSString    *pSession;
    NSString    *pNewPassword;
    NSString    *pPassword;
}

@end

@implementation UpdatePasswordCommand

- (instancetype)initUpdatePasswordCommandWithSession:(NSString *)session Password:(NSString *)password NewPassword:(NSString *)newPassword {
    if (self = [super init]) {
        opCode          = OperationCodeUpdatePassword;
        pSession        = session;
        pPassword       = password;
        pNewPassword    = newPassword;
    }
    return self;
}

- (NSData *)getCommandData {
    
    UpdatePasswordRequestMessage *requestMsg = [UpdatePasswordRequestMessage new];
    requestMsg.session      = pSession;
    requestMsg.password     = pPassword;
    requestMsg.newPassword  = pNewPassword;
    messageData             = [requestMsg data];
    
    return [super getCommandData];
}

@end
