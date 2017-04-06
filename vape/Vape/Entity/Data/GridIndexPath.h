//
//  GridIndexPath.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 * 该实体用于DataViewController
 * 被用来保存图表中被选中的Bar的位置信息
 **/
@interface GridIndexPath : NSObject

@property (assign, nonatomic)   NSInteger   pageIndex;
@property (assign, nonatomic)   NSInteger   barIndex;

-(instancetype)initPageIndex:(NSInteger)pageIndex andBarIndex:(NSInteger)barIndex;

@end
