//
//  AppEntryPageViewController.m
//  Vape
//
//  Created by Zhoucy on 2017/3/14.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "AppEntryPageViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface AppEntryPageViewController ()

- (IBAction)onExperienceButton:(UIButton *)sender;
- (IBAction)onLoginButton:(UIButton *)sender;
- (IBAction)onRegisterButton:(UIButton *)sender;

@end

@implementation AppEntryPageViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//=====================================================================================
#pragma mark - Button事件处理方法
//=====================================================================================
- (IBAction)onExperienceButton:(UIButton *)sender {
    [UserHelper loginByAnonymousUser];
    [[Utility getAppDelegate] setupRootTabBarViewController];
    //    AddDeviceViewController *addDeviceVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"AddDeviceViewController");
    //    [self.navigationController pushViewController:addDeviceVC animated:YES];
    
}

- (IBAction)onLoginButton:(UIButton *)sender {
    if ([UserHelper isLogin]) {
        [[Utility getAppDelegate] setupRootTabBarViewController];
    }
    else {
        LoginViewController *loginVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"LoginViewController");
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (IBAction)onRegisterButton:(UIButton *)sender {
    RegisterViewController *registerVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"RegisterViewController");
    [self.navigationController pushViewController:registerVC animated:YES];
}


@end
