//
//  PersonalInfoViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "EditNickNameViewController.h"
#import <NYXImagesKit/NYXImagesKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *const CellIdentifier           = @"LayoutCell";
static NSString *const UserIconCellIdentifier   = @"UserIconCell";


typedef NS_ENUM(NSInteger, TagValue) {
    TagValueTitleLabel          = 100101,
    TagValuebottomLine          = 100102,
    TagValueValueLabel          = 100103,
    TagValueTopLine             = 100104,
    TagValueUserIconImgView     = 100105
};


@interface PersonalInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditNickNameViewControllerDelegate> {
    NSArray             *titlesInLayoutTableView;   //个人信息标题数组
    
    NSArray             *sexStrings;                //描述性别的字符串数组
    NSArray             *homeInfoStrings;           //首页显示类型的字符串数组
    NSMutableArray      *ageStrings;                //描述年龄的字符串数组
    NSMutableArray      *smokingAgeStrings;         //描述烟龄的字符串数组
    NSMutableArray      *heightStrings;             //描述身高的字符串数组
    NSMutableArray      *weightStrings;             //描述体重的字符串数组
    
    
}


//布局表格
@property (weak, nonatomic) IBOutlet UITableView *layoutTableView;

@property (assign, nonatomic) UpdateProfileRequestMessage_SettingField  currentEditedSettingFieldType;
@property (assign, nonatomic) NSInteger                                 currentEditedSettingValue;
@property (strong, nonatomic) NSData                                    *currentEditedUserPhoto;


@end

@implementation PersonalInfoViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZED_STRING(keyPersonalInformation);//@"个人信息";
    
//    titlesInLayoutTableView = @[@[@"头像", @"昵称", @"性别", @"年龄", @"身高", @"体重", @"烟龄"],
//                                @[@"首页显示", @"吸烟计划"]];
    titlesInLayoutTableView = @[@[LOCALIZED_STRING(keyProfilePicture),
                                  LOCALIZED_STRING(keyNickname),
                                  LOCALIZED_STRING(keyGender),
                                  LOCALIZED_STRING(keyAge),
                                  LOCALIZED_STRING(keyHeight),
                                  LOCALIZED_STRING(keyWeight),
                                  LOCALIZED_STRING(keyYearOfSmoking)]];
//    titlesInLayoutTableView = @[@[LOCALIZED_STRING(keyProfilePicture),
//                                  LOCALIZED_STRING(keyNickname),
//                                  LOCALIZED_STRING(keyGender),
//                                  LOCALIZED_STRING(keyAge),
//                                  LOCALIZED_STRING(keyHeight),
//                                  LOCALIZED_STRING(keyWeight),
//                                  LOCALIZED_STRING(keyYearOfSmoking)],
//                                @[LOCALIZED_STRING(keyTheHomepage), LOCALIZED_STRING(keySmokingPlan)]];
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
//    sexStrings      = @[@"保密", @"男", @"女"];  //性别
//    homeInfoStrings = @[@"吸烟口数", @"吸烟时间"];  //首页显示类型
    sexStrings      = @[LOCALIZED_STRING(keyPrivacy), LOCALIZED_STRING(keyMale), LOCALIZED_STRING(keyFemale)];  //性别
    homeInfoStrings = @[LOCALIZED_STRING(keySmokingPuffs), LOCALIZED_STRING(keySmokingTime)];  //首页显示类型
    ageStrings      = [NSMutableArray new];  //年龄
//    [ageStrings addObject:@"保密"];
    [ageStrings addObject:LOCALIZED_STRING(keyPrivacy)];
    for (NSInteger i = kUserAge_Minimum_Value; i <= kUserAge_Maximum_Value; i++) {
        [ageStrings addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    heightStrings   = [NSMutableArray new];   //身高
//    [heightStrings addObject:@"保密"];
    [heightStrings addObject:LOCALIZED_STRING(keyPrivacy)];
    for (NSInteger i = kUserHeight_Minimum_Value; i <= kUserHeight_Maximum_Value; i++) {
        [heightStrings addObject:[NSString stringWithFormat:@"%ldcm", (long)i]];
    }
    weightStrings   = [NSMutableArray new];   //体重
//    [weightStrings addObject:@"保密"];
    [weightStrings addObject:LOCALIZED_STRING(keyPrivacy)];
    for (NSInteger i = kUserWeight_Minimum_Value; i <= kUserWeight_Maximum_Value; i++) {
        [weightStrings addObject:[NSString stringWithFormat:@"%ldkg", (long)i]];
    }
    smokingAgeStrings = [NSMutableArray new]; //烟龄
//    [smokingAgeStrings addObject:@"保密"];
    [smokingAgeStrings addObject:LOCALIZED_STRING(keyPrivacy)];
    for (NSInteger i = kSmokeAge_Minimum_Value; i <= kSmokeAge_Maximum_Value; i++) {
        [smokingAgeStrings addObject:[NSString stringWithFormat:@"%ld%@", (long)i, LOCALIZED_STRING(keyUnitYear)]];//@"年"
    }

}

//=====================================================================================
#pragma mark - UITableViewDataSource, UITableViewDelegate
//=====================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesInLayoutTableView.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[titlesInLayoutTableView objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 24;
    }
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == titlesInLayoutTableView.count -1) {
        return 24;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(indexPath.section==0 && indexPath.row==0) ? UserIconCellIdentifier : CellIdentifier
                                                            forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *titleLabel             = [cell.contentView viewWithTag:TagValueTitleLabel];
    UILabel *valueLabel             = [cell.contentView viewWithTag:TagValueValueLabel];
    UILabel *topLine                = [cell.contentView viewWithTag:TagValueTopLine];
    UILabel *bottomLine             = [cell.contentView viewWithTag:TagValuebottomLine];
    UIImageView *userIconImgView    = [cell.contentView viewWithTag:TagValueUserIconImgView];
    
    [titleLabel setText:[[titlesInLayoutTableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [valueLabel setHidden:(indexPath.section==1 && indexPath.row == 1) ? YES : NO];
    
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
    
    User *currentUser = [UserHelper currentUser];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: { /**头像*/
                    [userIconImgView sd_setImageWithURL:[NSURL URLWithString:currentUser.userPhotoUrl]
                                       placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
//                    [userIconImgView setImage:[UIImage imageWithData:currentUser.userPhoto]];
                    userIconImgView.layer.borderColor  = [UIColor whiteColor].CGColor;
                    userIconImgView.layer.borderWidth  = 1;
                }
                    break;
                case 1: { /**昵称*/
                    [valueLabel setText:currentUser.userName];
                }
                    break;
                case 2: { /**性别*/
                    [valueLabel setText:[sexStrings objectAtIndex:currentUser.userGender]];
                }
                    break;
                case 3: { /**年龄*/
                    NSInteger userAge = currentUser.userAge;
                    if (userAge == kUser_Security_Value) {
                        [valueLabel setText:[ageStrings objectAtIndex:kUser_Security_Value]];
                    }
                    else {
                        [valueLabel setText:[ageStrings objectAtIndex:(userAge-(kUserAge_Minimum_Value-1))]];
                    }
                }
                    break;
                case 4: { /**身高*/
                    NSInteger userHeight = currentUser.userHeight;
                    if (userHeight == kUser_Security_Value) {
                        [valueLabel setText:[heightStrings objectAtIndex:kUser_Security_Value]];
                    }
                    else {
                        [valueLabel setText:[heightStrings objectAtIndex:(userHeight-(kUserHeight_Minimum_Value-1))]];
                    }
                }
                    break;
                case 5: { /**体重*/
                    NSInteger userWeight = currentUser.userWeight;
                    if (userWeight == kUser_Security_Value) {
                        [valueLabel setText:[weightStrings objectAtIndex:kUser_Security_Value]];
                    }
                    else {
                        [valueLabel setText:[weightStrings objectAtIndex:(userWeight-(kUserWeight_Minimum_Value-1))]];
                    }
                }
                    break;
                case 6: { /**烟龄*/
                    [valueLabel setText:[smokingAgeStrings objectAtIndex:currentUser.smokeAge]];
                }
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: { /**首页显示*/
                    [valueLabel setText:[homeInfoStrings objectAtIndex:currentUser.homeInfo]];
                }
                    break;
                case 1: {
                    
                }
                    break;
            }
        }
            break;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User *currentUser = [UserHelper currentUser];
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: { /**头像*/
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCALIZED_STRING(keyUpdateProfilePicture)
                                                                             delegate:self
                                                                    cancelButtonTitle:LOCALIZED_STRING(keyCancel)
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:LOCALIZED_STRING(keyPhotograph), LOCALIZED_STRING(keyUploadFromAlbum), nil];//@"更换头像" @"拍照", @"从相册选择"
                    [actionSheet showInView:self.view];
                }
                    break;
                case 1: { /**昵称*/
                    if ([UserHelper isLogin]) {
                        EditNickNameViewController *editNickNameVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"EditNickNameViewController");
                        editNickNameVC.delegate = self;
                        [self.navigationController pushViewController:editNickNameVC animated:YES];
                    }
                    else {
                        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
                    }
                }
                    break;
                case 2: { /**性别*/
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:sexStrings
                                                  initialSelection:currentUser.userGender
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             
                                                             [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_UserGender
                                                                                                     SettingValue:selectedIndex];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
                case 3: { /**年龄*/
                    NSInteger userAge = currentUser.userAge;
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:ageStrings
                                                  initialSelection:(userAge==kUser_Security_Value?0:userAge-(kUserAge_Minimum_Value-1))
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             
                                                             NSInteger userAgeValue = (selectedIndex==kUser_Security_Value ? selectedIndex : selectedIndex + (kUserAge_Minimum_Value-1));
                                                             [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_UserAge
                                                                                                     SettingValue:userAgeValue];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];

                }
                    break;
                case 4: { /**身高*/
                    NSInteger userHeight = currentUser.userHeight;
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:heightStrings
                                                  initialSelection:(userHeight==kUser_Security_Value?0:userHeight-(kUserHeight_Minimum_Value-1))
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             
                                                             NSInteger userHeightValue = (selectedIndex==kUser_Security_Value ? selectedIndex : selectedIndex + (kUserHeight_Minimum_Value-1));
                                                             [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_UserHeight
                                                                                                     SettingValue:userHeightValue];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
                case 5: { /**体重*/
                    NSInteger userWeight = currentUser.userWeight;
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:weightStrings
                                                  initialSelection:(userWeight==kUser_Security_Value?0:userWeight-(kUserWeight_Minimum_Value-1))
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             
                                                             NSInteger userWeightValue = (selectedIndex==kUser_Security_Value ? selectedIndex : selectedIndex + (kUserWeight_Minimum_Value-1));
                                                             [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_UserWeight
                                                                                                     SettingValue:userWeightValue];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
                case 6: { /**烟龄*/
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:smokingAgeStrings
                                                  initialSelection: currentUser.smokeAge
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             
                                                             [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_SmokeAge
                                                                                                     SettingValue:selectedIndex];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: { /**首页显示*/
                    ActionSheetStringPicker *picker =
                    [[ActionSheetStringPicker alloc] initWithTitle:nil
                                                              rows:homeInfoStrings
                                                  initialSelection: currentUser.homeInfo
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             
                                                             [weakSelf sendUpdateProfileCommandBySettingFieldType:UpdateProfileRequestMessage_SettingField_HomeInfo
                                                                                                     SettingValue:selectedIndex];
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           
                                                       }
                                                            origin:self.view];
                    picker.toolbarButtonsColor = kNavigationBar_Bg_Color;
                    [picker showActionSheetPicker];
                }
                    break;
                case 1: {
                    if ([UserHelper isLogin]) {
                        BaseViewController *editSmokingPlanVC = VIEW_CONTROLLER_IN_STORYBOARD(kStoryboard_Name_Me, @"EditSmokingPlanViewController");
                        [self.navigationController pushViewController:editSmokingPlanVC animated:YES];
                    }
                    else {
                        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
                    }
                }
                    break;
            }
        }
            break;
    }
    
}


//=====================================================================================
#pragma mark - UIActionSheetDelegate
//=====================================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    if (buttonIndex == 0) {
        //拍照
        if (![Utility checkCameraAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        //相册
        if (![Utility checkPhotoLibraryAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    
}



//=====================================================================================
#pragma mark - UIImagePickerControllerDelegate
//=====================================================================================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage, *originalImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if ([UserHelper isLogin]) {
            [Utility showIndicatorHUD:@""];
            
            //========================压缩图片==========================
            CGSize maxSize = CGSizeMake(600, 600);
            if (editedImage.size.width > maxSize.width || editedImage.size.height > maxSize.height) {
                editedImage = [editedImage scaleToSize:maxSize usingMode:NYXResizeModeAspectFit];
            }
            NSData *editedImageData = [editedImage dataForCodingUpload];
            //=========================================================
            
            weakSelf.currentEditedUserPhoto = editedImageData;
            UpdateProfileCommand *updateProfileCommand = [[UpdateProfileCommand alloc] initUpdateProfileCommandWithSession:[UserHelper currentUserSession] UserPhoto:weakSelf.currentEditedUserPhoto];
            [[TcpCommandHelper shareTcpCommandHelperWithDelegate:weakSelf] sendCommand:updateProfileCommand];
        }
        else {
            [weakSelf showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
        }
        
        // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, weakSelf, nil, NULL);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//=====================================================================================
#pragma mark - EditNickNameViewControllerDelegate
//=====================================================================================
-(void)didSaveNickName:(NSString *)nickName {
    UITableViewCell *nickNameCell = [self.layoutTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *nickNameLabel = [nickNameCell.contentView viewWithTag:TagValueValueLabel];
    [nickNameLabel setText:nickName];
}

//=====================================================================================
#pragma mark - 发送更新用户信息Socket命令
//=====================================================================================
- (void)sendUpdateProfileCommandBySettingFieldType:(UpdateProfileRequestMessage_SettingField)settingFieldType SettingValue:(NSInteger)settingValue {
    self.currentEditedSettingFieldType  = settingFieldType;
    self.currentEditedSettingValue      = settingValue;
    if ([UserHelper isLogin]) {
        [Utility showIndicatorHUD:@""];
        UpdateProfileCommand *updateProfileCommand = [[UpdateProfileCommand alloc] initUpdateProfileCommandWithSession:[UserHelper currentUserSession]
                                                                                                          SettingField:settingFieldType
                                                                                                          SettingValue:[NSString stringWithFormat:@"%ld", (long)settingValue]];
        [[TcpCommandHelper shareTcpCommandHelperWithDelegate:self] sendCommand:updateProfileCommand];
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
}

//=====================================================================================
#pragma mark - TcpCommandHelperDelegate
//=====================================================================================
/**
 * Socket调用正常返回
 **/
- (void)didCommandSuccessWithResult:(NSData *)result andOpCode:(OperationCode)opCode {
    [super didCommandSuccessWithResult:result andOpCode:opCode];
    [Utility hideIndicatorHUD];
    if ([UserHelper isLogin]) {
        if (opCode == OperationCodeUpdateProfile) {
            NSError *error;
            UpdateProfileResponseMessage *updateProfileResponseMsg = [UpdateProfileResponseMessage parseFromData:result error:&error];
            if (error == nil && updateProfileResponseMsg.errorMsg.errorCode == 0) {
                switch (self.currentEditedSettingFieldType) {
                    case UpdateProfileRequestMessage_SettingField_UserGender: {
                        [UserHelper currentUser].userGender = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_UserAge: {
                        [UserHelper currentUser].userAge = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_UserHeight: {
                        [UserHelper currentUser].userHeight = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_UserWeight: {
                        [UserHelper currentUser].userWeight = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_SmokeAge: {
                        [UserHelper currentUser].smokeAge = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_HomeInfo: {
                        [UserHelper currentUser].homeInfo = self.currentEditedSettingValue;
                    }
                        break;
                    case UpdateProfileRequestMessage_SettingField_UserPhoto: {
                        if (updateProfileResponseMsg.photoURL != nil && ![updateProfileResponseMsg.photoURL isEqualToString:@""]) {
                            [UserHelper currentUser].userPhotoUrl = updateProfileResponseMsg.photoURL;
                            [UserHelper synchronizeCurrentUser];
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
                [UserHelper synchronizeCurrentUser];
                [self.layoutTableView reloadData];
                [self showSuccessMessage:LOCALIZED_STRING(keyPersonalInformationUpdated)];//@"更新用户信息成功"
            }
            else {
                [self showErrorMessage:(updateProfileResponseMsg==nil?LOCALIZED_STRING(keyPersonalInformationUpdateFailed):updateProfileResponseMsg.errorMsg.errorMsg)];//@"更新用户信息失败"
                if (error ==nil && updateProfileResponseMsg.errorMsg.errorCode == ReturnErrorCodeSessionExpired) {
                    [UserHelper presentLoginViewControllerByIsSessionExpired:YES];
                }
            }
        }
    }
    else {
        [self showErrorMessage:LOCALIZED_STRING(keyPleaseLogin)];
    }
    
}

/**
 * Socket调用异常返回
 **/
- (void)didCommandFailWithErrorCode:(NSInteger)errorCode andErrorMsg:(NSString *)errorMsg andOpCode:(OperationCode)opCode {
    [super didCommandFailWithErrorCode:errorCode andErrorMsg:errorMsg andOpCode:opCode];
    
}









@end
