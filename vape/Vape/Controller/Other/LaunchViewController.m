//
//  LaunchViewController.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "LaunchViewController.h"
#import "Utility.h"

@interface LaunchViewController ()


@property (weak, nonatomic) IBOutlet UIView         *bgView;
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;

@property (assign, nonatomic) CGAffineTransform     bgViewTransform;
@property (assign, nonatomic) CGAffineTransform     imageViewTransform;
@end

@implementation LaunchViewController

//=====================================================================================
#pragma mark - 控制器生命周期方法
//=====================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *images = @[[UIImage imageNamed:@"launchImg1"],
                        [UIImage imageNamed:@"launchImg2"],
                        [UIImage imageNamed:@"launchImg3"],
                        [UIImage imageNamed:@"launchImg4"],
                        [UIImage imageNamed:@"launchImg5"],
                        [UIImage imageNamed:@"launchImg6"],
                        [UIImage imageNamed:@"launchImg7"]];
    [self.imageView setAnimationImages:images];
    [self.imageView setAnimationDuration:3.0];
    [self.imageView setAnimationRepeatCount:1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bgViewTransform = self.bgView.transform;
    self.imageViewTransform = self.imageView.transform;
    [self.imageView startAnimating];
    __weak LaunchViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DebugLog(@"%@", self);
        [weakSelf.titleLabel setHidden:NO];
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.imageView.transform = CGAffineTransformScale(weakSelf.imageViewTransform, 1.3, 1.3);
//            [weakSelf.titleLabel setFont:[UIFont boldSystemFontOfSize:17*1.8]];
        } completion:^(BOOL finished) {

            
        }];
        
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.titleLabel.transform = CGAffineTransformScale(weakSelf.titleLabel.transform, 1.6, 1.6);
        } completion:^(BOOL finished) {
            
            
        }];
        
        [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.imageView.transform = weakSelf.imageViewTransform;
//            [weakSelf.titleLabel setFont:[UIFont boldSystemFontOfSize:17*1.3]];
        } completion:^(BOOL finished) {
            
        }];
        
        
        [UIView animateWithDuration:0.6 delay:1.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [weakSelf.imageView stopAnimating];
            [weakSelf.view setX:-kScreen_Width];
        } completion:^(BOOL finished) {
            [weakSelf.view removeFromSuperview];
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
