//
//  StringHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>


//======================================================================================================
#pragma mark - 常用工具
//======================================================================================================

/**
 * read localized string
 **/
#define LOCALIZED_STRING(StringKey) NSLocalizedString(StringKey, nil)


/**
 * string in string length
 **/
#define IN_STRING_LENGTH(SourceString, targetString) [targetString rangeOfString:SourceString options:NSCaseInsensitiveSearch].length

/**
 * string in string location
 **/
#define IN_STRING_LOCATION(SourceString, targetString) [targetString rangeOfString:SourceString options:NSCaseInsensitiveSearch].location


//======================================================================================================
#pragma mark - Storyboard的名称宏
//======================================================================================================
#define kStoryboard_Name_Main               @"Main"
#define kStoryboard_Name_Home               @"Home"
#define kStoryboard_Name_Data               @"Data"
#define kStoryboard_Name_Discovery          @"Discovery"
#define kStoryboard_Name_Me                 @"Me"
#define kStoryboard_Name_Member             @"Member"



//======================================================================================================
#pragma mark - Localizable.strings文件中的KEY
//======================================================================================================

//====================================================================================
//通用标签字符串
//====================================================================================
#define keyCancel           	@"Cancel"
#define keyConfirm          	@"Confirm"
#define keySubmit          		@"Submit"
#define keyFinish            	@"Finish"
#define keyRetry           		@"Retry"
#define keyDelete               @"Delete"
#define keySettings             @"Settings"

#define keyUnitSecond           @"UnitSecond"
#define keyUnitYear             @"UnitYear"
#define keyUnitPuffs            @"UnitPuffs"

#define keyPrompt               @"Prompt"
#define keyHistory           	@"History"



//====================================================================================
//TabBar
//====================================================================================
#define keyHome             @"Home"
#define keyData             @"Data"
#define keyDiscover         @"Discover"
#define keyMe               @"Me"


//====================================================================================
//控制器
//====================================================================================

/****************Experience*******************/
#define keyToTry            @"ToTry"
#define keyRegisterNow      @"RegisterNow"

/****************LoginOrRegister*******************/
#define keyLogIn            @"LogIn"
#define keyLogOut           @"LogOut"
#define keyRegister         @"Register"

#define keySMSCode          @"SMSCode"
#define keySendSMSCode      @"SendSMSCode"
#define keyEnterSMSCode     @"EnterSMSCode"
#define keyForgotPassword   @"ForgotPassword"
#define keyPhoneNumber      @"PhoneNumber"
#define keyPassword         @"Password"

#define keyVerify           @"Verify"
#define keySetPassword      @"SetPassword"

/****************Home*******************/
#define keyPlan      				@"Plan"
#define keyHeartRate     			@"HeartRate"
#define keyBloodOxygen   			@"BloodOxygen"
#define keyBloodOxygenSaturation    @"BloodOxygenSaturation"
#define keySmokingPuffsToday        @"SmokingPuffsToday"
#define keySmokingTimeToday      	@"SmokingTimeToday"
#define keyHeartRateAndBloodOxygen  @"HeartRateAndBloodOxygen"
#define keyStartingTest   			@"StartingTest"
#define keyTimesPerSecond           @"TimesPerSecond"

/****************Data*******************/
#define keyHour            	@"Hour"
#define keyDay           	@"Day"
#define keyMonth           	@"Month"
#define keyYear         	@"Year"

#define keySmokingPuffs     @"SmokingPuffs"
#define keySmokingTime     	@"SmokingTime"
#define keySmokingAmount   	@"SmokingAmount"

#define keyFew      		@"Few"
#define keyMore         	@"More"
#define keyOverdose         @"Overdose"

#define keySmokingPlace     @"SmokingPlace"

#define keyToday      		@"Today"
#define keyYesterday        @"Yesterday"
#define keyTomorrow      	@"Tomorrow"

/****************Discover*******************/
#define keyPublish         		@"Publish"
#define keyReply                @"Reply"
#define keyEnterYouWantToSay	@"EnterYouWantToSay"
#define keyPost                 @"Post"

#define keyLocation             @"Location"
#define keyComments     		@"Comments"
#define keyComment      		@"Comment"
#define keyLike                 @"Like"
#define key_PeopleLiked         @"_PeopleLiked"

#define keySorry                @"Sorry"

/****************Me*******************/
#define keyPersonalInformation 	@"PersonalInformation"
#define keyAccountSettings      @"AccountSettings"
#define keyDeviceSettings       @"DeviceSettings"
#define keySystemSettings       @"SystemSettings"
#define keyShop         		@"Shop"

#define keyAddDevice     		@"AddDevice"
#define keyDisconnected     	@"Disconnected"
#define keyConnected   			@"Connected"

#define keyDeviceName      		@"DeviceName"
#define keyModeAndParameter     @"ModeAndParameter"
#define keyUnbind         		@"Unbind"

#define keySearchingDevice     			@"SearchingDevice"
#define keyLetDeviceClosedToThePhone    @"LetDeviceClosedToThePhone"
#define keyNotAdd      					@"NotAdd"
#define keyAdd         					@"Add"

#define keyWorkMode             @"WorkMode"
#define keyParameter      		@"Parameter"
#define keyPowerMode      		@"PowerMode"
#define keyTemperatureModeC     @"TemperatureModeC"
#define keyTemperatureModeF     @"TemperatureModeF"

#define keyPasswordEdit     	@"PasswordEdit"
#define keyCurrentPassword     	@"CurrentPassword"
#define keyNewPassword     		@"NewPassword"
#define keyConfirmNewPassword   @"ConfirmNewPassword"

#define keySystemLanguage      	@"SystemLanguage"
#define keySoftwareVersion      @"SoftwareVersion"
#define keyChinese         		@"Chinese"
#define keyEnglish     			@"English"

/****************个人信息*******************/
#define keyProfilePicture    	@"ProfilePicture"
#define keyNickname     		@"Nickname"
#define keyGender      			@"Gender"
#define keyAge      			@"Age"
#define keyHeight         		@"Height"
#define keyWeight         		@"Weight"
#define keyYearOfSmoking     	@"YearOfSmoking"
#define keyPrivacy      		@"Privacy"
#define keyMale      			@"Male"
#define keyFemale     			@"Female"

#define keyUpdateProfilePicture @"UpdateProfilePicture"
#define keyPhotograph      		@"Photograph"
#define keyUploadFromAlbum      @"UploadFromAlbum"

#define keyPlanSettings             @"PlanSettings"
#define keyTheHomepage         		@"TheHomepage"
#define keySmokingPlan     			@"SmokingPlan"
#define keySmokingPuffsPlanForToday @"SmokingPuffsPlanForToday"
#define keySmokingTimePlanForToday  @"SmokingTimePlanForToday"

#define keySmokingPuffsUnit 	@"SmokingPuffsUnit"//英文版省略单位
#define keySmokingTimeUnit    	@"SmokingTimeUnit"

#define keyPleaseEnterUserNickname @"PleaseEnterUserNickname"

//====================================================================================
// 提示消息文本
//====================================================================================
#define keyPleaseLogin 					@"PleaseLogin"
#define keyTryAgain      				@"TryAgain"

#define keyBluetoothNotEnabled       	@"BluetoothNotEnabled"
#define keyDeviceConnected       		@"DeviceConnected"
#define keyDeviceDisconnected         	@"DeviceDisconnected"
#define keyNoBindedDeviceToReconnect    @"NoBindedDeviceToReconnect"
#define keyReconnectionTimeout     		@"ReconnectionTimeout"

#define keyGetVerificationCodeSuccessful   			@"GetVerificationCodeSuccessful"
#define keyGetVerificationCodeFailed      			@"GetVerificationCodeFailed"
#define keyPleaseEnterTheCorrectVerificationCode    @"PleaseEnterTheCorrectVerificationCode"
#define keyLoginSuccessful         					@"LoginSuccessful"
#define keyLoginFailed     							@"LoginFailed"
#define keyRegistrationSuccessful    				@"RegistrationSuccessful"
#define keyRegistrationFailed    					@"RegistrationFailed"

#define keyResetPasswordSuccessfully      			@"ResetPasswordSuccessfully"
#define keyResetPasswordFailed         				@"ResetPasswordFailed"
#define keyPasswordChanged      					@"PasswordChanged"
#define keyPasswordChangeFailed         			@"PasswordChangeFailed"

#define keyNotFoundTheDevicePleaseEnsureTheDeviceScreenBrightAndCloseItToThePhone  @"NotFoundTheDevicePleaseEnsureTheDeviceScreenBrightAndCloseItToThePhone"
#define keyConnectionTimeout      					@"ConnectionTimeout"
#define keyInitializationFailed      				@"InitializationFailed"

#define keyPleaseAddDevice     						@"PleaseAddDevice"
#define keyDeviceNameCannotBeEmpty      			@"DeviceNameCannotBeEmpty"
#define keyDeviceSetupSuccessful      				@"DeviceSetupSuccessful"
#define keyDeviceSetupFailed     					@"DeviceSetupFailed"

#define keyPersonalInformationUpdated     			@"PersonalInformationUpdated"
#define keyPersonalInformationUpdateFailed     		@"PersonalInformationUpdateFailed"

#define keySmokingPlanSetUpSuccessful     			@"SmokingPlanSetUpSuccessful"
#define keySmokingPlanSetUpFailed     				@"SmokingPlanSetUpFailed"

#define keySynchronousDataSuccessfully              @"SynchronousDataSuccessfully"
#define keySynchronousDataFailed                    @"SynchronousDataFailed"

#define keyNoSmokingAddressData      				@"NoSmokingAddressData"

#define keyHeartRateAndBloodOxygenDetectionFailedPleaseCheckIfTheDeviceConnectedProperly  @"HeartRateAndBloodOxygenDetectionFailedPleaseCheckIfTheDeviceConnectedProperly"

#define keyNoNetworkPleaseCheckTheNetworkSettings  @"NoNetworkPleaseCheckTheNetworkSettings"

#define keyNotConnectedToTheDevicePleaseConnectTheDeviceAndThenTryAgain @"NotConnectedToTheDevicePleaseConnectTheDeviceAndThenTryAgain"

#define keyAreYouSureYouWantToDeleteIt @"AreYouSureYouWantToDeleteIt"

#define keyLoadFailure          @"LoadFailure"

#define keyPleaseOpenTheLocationServiceToAllowAPPToAccessYourLocationInformation @"PleaseOpenTheLocationServiceToAllowAPPToAccessYourLocationInformation"

#define keyDoYouWantToExitTheEditor         @"DoYouWantToExitTheEditor"
#define keyPleaseUploadAtLeastOnePicture    @"PleaseUploadAtLeastOnePicture"
#define keyFailedToObtainUserLocation       @"FailedToObtainUserLocation"
#define keyPostFailure                      @"PostFailure"
#define keyDeletePostFailed                 @"DeletePostFailed"
#define keyDeleteCommentFailed              @"DeleteCommentFailed"
#define keyLikeFailure                      @"LikeFailure"
#define keyNoData                           @"NoData"


#define keyCanNotJumpToThePrivacySettingsPagePleaseGoToTheSettingsPageManually      			@"CanNotJumpToThePrivacySettingsPagePleaseGoToTheSettingsPageManually"
#define keyUnableToAccessAlbum      				@"UnableToAccessAlbum"
#define keyUnableToUseCamera     					@"UnableToUseCamera"
#define keyPleaseAllowAccessToAlbumsIniPhoneSettingsPrivacyPhotos                   @"PleaseAllowAccessToAlbumsIniPhoneSettingsPrivacyPhotos"
#define keyPleaseAllowAccessToTheCameraInTheiPhoneSettingsPrivacyCamera     		@"PleaseAllowAccessToTheCameraInTheiPhoneSettingsPrivacyCamera"

#define keyDoYouWantToEnterTheMall  @"DoYouWantToEnterTheMall"

#define keyShareSuccess         @"ShareSuccess"
#define keyShareFailure         @"ShareFailure"

#define keyTheDeviceDoesNotSupportTakingPictures         @"TheDeviceDoesNotSupportTakingPictures"

#define keyMallSiteIsUnderConstructionPleaseLookForwardToIt     @"MallSiteIsUnderConstructionPleaseLookForwardToIt"

//====================================================================================
// 通用消息文本
//====================================================================================
#define keyFormatOf_NotCorrect      @"FormatOf_NotCorrect"
#define keyLengthOf_MustBe_To_      @"LengthOf_MustBe_To_"
#define key_And_Inconsistent        @"_And_Inconsistent"
#define key_CanNotBeBlank           @"_CanNotBeBlank"



