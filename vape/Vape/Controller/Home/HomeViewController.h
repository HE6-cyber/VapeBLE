//
//  HomeViewController.h
//  Vape
//
//  Created by Zhoucy on 2017/3/6.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

//UIView 有操作到的视图控制器之中的view
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIView *backGroundColorView;

//UIButton collection
@property (strong, nonatomic) IBOutlet UIButton *heartRateTestButton;

//UILable 需要控制值的视图控制器之中的label
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@property (strong, nonatomic) IBOutlet UILabel *modelInfomationLabel;
@property (strong, nonatomic) IBOutlet UILabel *electricResistanceLabel;

//需要设置颜色的label
@property (strong, nonatomic) IBOutlet UILabel *workModelLabel;


@end
