//
//  AppSettingViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "AppSettingViewController.h"
#import "LanguageHelper.h"

static NSString *const CellIdentifier   = @"LayoutCell";

typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104,
    TagValueRightArrowImgView   = 100105
};

@interface AppSettingViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray     *titlesInLayoutTableView;   //个人信息标题数组
}

//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (strong, nonatomic) NSArray   *languageStrings;
@property (strong, nonatomic) NSArray   *languageValues;

@end

@implementation AppSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keySystemSettings);//@"系统设置";
//    titlesInLayoutTableView = @[@"系统语言", @"软件版本"];
    titlesInLayoutTableView = @[LOCALIZED_STRING(keySystemLanguage), LOCALIZED_STRING(keySoftwareVersion)];
    [self setupStringPickerData];
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
#pragma mark - 辅助方法
//=====================================================================================
/**
 * 配置选取器用到的数据
 **/
- (void)setupStringPickerData {
//    self.languageStrings = @[@"中文", @"English"]; //语言
    self.languageStrings = @[LOCALIZED_STRING(keyChinese), LOCALIZED_STRING(keyEnglish)]; //语言
    self.languageValues = @[kLanguage_SimplifiedChinese, kLanguage_English];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *titleLabel             = [cell.contentView viewWithTag:TagValueTitleLabel];
    UILabel *valueLabel             = [cell.contentView viewWithTag:TagValueValueLabel];
    UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
    UIImageView *rightArrowImgView  = [cell.contentView viewWithTag:TagValueRightArrowImgView];
    
    [titleLabel setText:[titlesInLayoutTableView objectAtIndex:indexPath.section]];
    
    [topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomLine.superview.mas_leading);
        make.height.mas_equalTo(@(kBorder_Line_Height));
    }];
    
    if (indexPath.section == 0) {
        NSInteger languageIndex = [[[LanguageHelper shareLanguageHelper] currentLanguageName] isEqualToString:kLanguage_SimplifiedChinese]?0:1;
        [valueLabel setText:self.languageStrings[languageIndex]];
        [rightArrowImgView setHidden:NO];
    }
    else {
        [valueLabel setText:[Utility getAppVersion]];
        [rightArrowImgView setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *valueLabel = [cell.contentView viewWithTag:TagValueValueLabel];
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"功能开发中，敬请期待" message:nil delegate:nil cancelButtonTitle:LOCALIZED_STRING(keyCancel) otherButtonTitles:nil];
//        [alertView show];
//        return;
        ActionSheetStringPicker *picker =
        [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                  rows:self.languageStrings
                                      initialSelection:([[[LanguageHelper shareLanguageHelper] currentLanguageName] isEqualToString:kLanguage_SimplifiedChinese]?0:1)
                                             doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                 [valueLabel setText:selectedValue];
                                                 if (![[[LanguageHelper shareLanguageHelper] currentLanguageName] isEqualToString:weakSelf.languageValues[selectedIndex]]) {
                                                     [[LanguageHelper shareLanguageHelper] setCurrentLanguageName:weakSelf.languageValues[selectedIndex]];
                                                     [[Utility getAppDelegate] setupRootTabBarViewController];
                                                 }
                                             }
                                           cancelBlock:^(ActionSheetStringPicker *picker) {
                                               
                                           }
                                                origin:self.view];
        picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
        [picker showActionSheetPicker];
    }
    
}

@end
