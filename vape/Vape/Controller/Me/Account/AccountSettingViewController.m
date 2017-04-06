//
//  AccountSettingViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "LoginViewController.h"

static NSString *const CellIdentifier       = @"LayoutCell";
static NSString *const ButtonCellIdentifier = @"LayoutButtonCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104
};

@interface AccountSettingViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray             *titlesInLayoutTableView;   //个人信息标题数组
}

//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@end

@implementation AccountSettingViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyAccountSettings);//@"账号设置";
//    titlesInLayoutTableView = @[@"修改密码", @"退出账号"];
    titlesInLayoutTableView = @[LOCALIZED_STRING(keyPasswordEdit), LOCALIZED_STRING(keyLogOut)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesInLayoutTableView.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 32;
    }
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == titlesInLayoutTableView.count -1) {
        return 32;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UILabel *titleLabel             = [cell.contentView viewWithTag:TagValueTitleLabel];
            UILabel *valueLabel             = [cell.contentView viewWithTag:TagValueValueLabel];
            UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
            UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
            
            [titleLabel setText:[titlesInLayoutTableView objectAtIndex:indexPath.section]];
            [valueLabel setHidden:YES];
            [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(kBorder_Line_Height));
            }];
            [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(bottomLine.superview.mas_leading);
                make.height.mas_equalTo(@(kBorder_Line_Height));
            }];
        }
            break;
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier forIndexPath:indexPath];
        }
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if ([UserHelper isLogin]) {
                BaseViewController *changePasswordVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"ChangePasswordViewController");
                [self.navigationController pushViewController:changePasswordVC animated:YES];
            }
            else {
                [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
            }
        }
            break;
        case 1: { //注销
            [UserHelper loginByAnonymousUser];
            [self.navigationController popViewControllerAnimated:YES];
            //        LoginOrRegisterViewController *loginVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"LoginOrRegisterViewController");
            //        loginVC.controllerType = LoginOrRegisterViewControllerTypeLogin;
            //        loginVC.isBackToPreviousFunction = YES;
            //        BaseNavigationController *navigationVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            //        [self presentViewController:navigationVC animated:YES completion:^{
            //            NSLog(@"Login finished!");
            //        }];
        }
            break;
    }
    
}

@end
