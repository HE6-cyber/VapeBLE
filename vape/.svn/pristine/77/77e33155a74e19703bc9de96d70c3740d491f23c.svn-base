//
//  UpdateProfileCommand.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "UpdateProfileCommand.h"

@interface UpdateProfileCommand () {
    NSString                                    *pSession;
    UpdateProfileRequestMessage_SettingField    pSettingField;
    NSString                                    *pSettingValue;
    NSData                                      *pUserPhoto;
}

@end

@implementation UpdateProfileCommand

- (instancetype)initUpdateProfileCommandWithSession:(NSString *)session SettingField:(UpdateProfileRequestMessage_SettingField)settingField SettingValue:(NSString *)settingValue {
    if (self = [super init]) {
        opCode          = OperationCodeUpdateProfile;
        pSession        = session;
        pSettingField   = settingField;
        pSettingValue   = settingValue;
    }
    return self;
}

- (instancetype)initUpdateProfileCommandWithSession:(NSString *)session UserPhoto:(NSData *)userPhoto {
    if (self = [super init]) {
        opCode          = OperationCodeUpdateProfile;
        pSession        = session;
        pSettingField   = UpdateProfileRequestMessage_SettingField_UserPhoto;
        pUserPhoto      = userPhoto;
    }
    return self;
}

- (NSData *)getCommandData {
    UpdateProfileRequestMessage *requestMsg = [UpdateProfileRequestMessage new];
    requestMsg.session      = pSession;
    requestMsg.settingField = pSettingField;
    requestMsg.settingValue = pSettingValue;
    requestMsg.photo        = pUserPhoto;
    messageData             = [requestMsg data];
    return [super getCommandData];
}

@end
