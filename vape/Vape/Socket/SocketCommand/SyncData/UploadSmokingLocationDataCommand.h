//
//  UploadSmokingLocationDataCommand.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "OperationCommand.h"

@interface UploadSmokingLocationDataCommand : OperationCommand

- (instancetype)initUploadSmokingLocationDataCommandWithWithSession:(NSString *)session SmokingLocationDataMsgs:(NSArray *)smokingLocationDataMsgs;

@end
