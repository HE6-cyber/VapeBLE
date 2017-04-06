//
//  PhotoCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "PhotoCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCell ()

@end

@implementation PhotoCell

//=====================================================================
#pragma mark - 初始化方法
//=====================================================================
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImgView.backgroundColor   = [UIColor colorWithWhite:1.000 alpha:0.500];
    self.photoImgView.contentMode       = UIViewContentModeScaleAspectFill;
    self.photoImgView.clipsToBounds     = YES;
}


@end
