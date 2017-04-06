//
//  NSManagedObject+Custom.h
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

@interface NSManagedObject (Custom)

/**
 *  Added by Zhoucy  2015-8-3 11:34
 *
 *  @param collectionOperator   聚合操作名称
 *  @param attributeNames       每个属性名所指定的字段被单独进行聚合操作，并且该属性名被作为返回结果集的key
 *  @param predicate            筛选要进行聚合操作的记录
 *  @param groupingKeyPaths     使用指定字段进行分组，可指定多个字段
 *  @param context              执行操作的上下文
 *
 *  @返回聚合操作的结果集,结果集中包含了attributeNames、groupingKeyPaths所指定的字段
 */
+ (NSArray *) MR_aggregateOperation:(NSString *)collectionOperator onAttributes:(NSArray *)attributeNames withPredicate:(NSPredicate *)predicate groupBy:(NSArray *)groupingKeyPaths HavingPredicate:(NSPredicate *)havingPredicate SortTerm:(NSString *)sortTerm Ascending:(BOOL)ascending FetchLimit:(NSUInteger)fetchLimit inContext:(NSManagedObjectContext *)context;

///Added by Zhoucy  2015-8-5 23:02
+ (NSArray *)MR_aggregateOperation:(NSString *)collectionOperator onAttributes:(NSArray *)attributeNames withPredicate:(NSPredicate *)predicate groupBy:(NSArray *)groupingKeyPaths HavingPredicate:(NSPredicate *)havingPredicate SortTerm:(NSString *)sortTerm Ascending:(BOOL)ascending FetchLimit:(NSUInteger)fetchLimit;

+ (NSArray *)MR_aggregateOperation:(NSString *)collectionOperator onAttributes:(NSArray *)attributeNames withPredicate:(NSPredicate *)predicate groupBy:(NSArray *)groupingKeyPaths;


+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm FetchLimit:(NSUInteger)fetchLimit inContext:(NSManagedObjectContext *)context;

@end
