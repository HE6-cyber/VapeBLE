//
//  SettingViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "SettingViewController.h"

static NSString *const CellIdentifier       = @"LayoutCell";
static NSString *const ButtonCellIdentifier = @"LayoutButtonCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueTopLine             = 100104
};

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray             *titlesInLayoutTableView;   //标题字符串数组
    
}

//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@end

@implementation SettingViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keySettings);
    titlesInLayoutTableView = @[@[@"修改密码", @"意见反馈", @"去评分"], @[@"退出账号"]];
   
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
#pragma mark - UIButton事件处理方法
//=====================================================================================

//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesInLayoutTableView.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[titlesInLayoutTableView objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *titleLabel = [cell.contentView viewWithTag:TagValueTitleLabel];
        UILabel *topLine    = [cell.contentView viewWithTag:TagValueTopLine];
        UILabel *bottomLine = [cell.contentView viewWithTag:TagValuebottomLine];
        
        [titleLabel setText:[[titlesInLayoutTableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        
        if (indexPath.row == 0) {
            [topLine setHidden:NO];
            [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(kBorder_Line_Height));
            }];
        }
        else {
            [topLine setHidden:YES];
        }
        
        if (indexPath.row == ([titlesInLayoutTableView[indexPath.section] count] - 1)) {
            [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(bottomLine.superview.mas_leading);
                make.height.mas_equalTo(@(kBorder_Line_Height));
            }];
        }
        else {
            [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(bottomLine.superview.mas_leading).offset(16);
                make.height.mas_equalTo(@(kBorder_Line_Height));
            }];
        }
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BaseViewController *changePasswordVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Member, @"ChangePasswordViewController");
            [self.navigationController pushViewController:changePasswordVC animated:YES];
        }
    }
    else if (indexPath.section == 1) {
        
    }
    
}

@end
