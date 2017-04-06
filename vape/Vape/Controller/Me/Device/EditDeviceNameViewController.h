//
//  EditDeviceNameViewController.h
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BaseViewController.h"

@protocol EditDeviceNameViewControllerDelegate;

@interface EditDeviceNameViewController : BaseViewController

@property (weak, nonatomic) id<EditDeviceNameViewControllerDelegate> delegate;

@end


@protocol EditDeviceNameViewControllerDelegate <NSObject>

-(void)didSaveDeviceName:(NSString*)deviceName;

@end
