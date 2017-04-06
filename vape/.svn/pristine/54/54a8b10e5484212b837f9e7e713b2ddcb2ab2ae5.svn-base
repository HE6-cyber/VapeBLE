//
//  NSManagedObject+Custom.m
//  Vape
//
//  Created by Zhoucy on 2017/3/2.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "NSManagedObject+Custom.h"

@implementation NSManagedObject (Custom)

///Added by Zhoucy  2015-8-3 11:34
+ (NSArray *) MR_aggregateOperation:(NSString *)collectionOperator onAttributes:(NSArray *)attributeNames withPredicate:(NSPredicate *)predicate groupBy:(NSArray *)groupingKeyPaths HavingPredicate:(NSPredicate *)havingPredicate SortTerm:(NSString *)sortTerm Ascending:(BOOL)ascending FetchLimit:(NSUInteger)fetchLimit inContext:(NSManagedObjectContext *)context;
{
    NSMutableArray *expressionDescriptions = [NSMutableArray new];
    for(NSString *attributeName in attributeNames) {
        
        NSExpression *expression = [NSExpression expressionForFunction:collectionOperator arguments:@[[NSExpression expressionForKeyPath:attributeName]]];
        
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        
        [expressionDescription setName:attributeName];
        [expressionDescription setExpression:expression];
        
        NSAttributeDescription *attributeDescription = [[[self MR_entityDescriptionInContext:context] attributesByName] objectForKey:attributeName];
        [expressionDescription setExpressionResultType:[attributeDescription attributeType]];
        
        [expressionDescriptions addObject:expressionDescription];
    }
    
    [expressionDescriptions addObjectsFromArray:groupingKeyPaths];
    
    NSFetchRequest *fetchRequest = [self MR_requestAllWithPredicate:predicate inContext:context];
    [fetchRequest setPropertiesToFetch:expressionDescriptions];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToGroupBy:groupingKeyPaths];
    [fetchRequest setHavingPredicate:havingPredicate];
    [fetchRequest setFetchLimit:fetchLimit];
    
    if (sortTerm != nil && sortTerm.length > 0) {
        NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
        NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
        for (__strong NSString* sortKey in sortKeys) {
            NSArray * sortComponents = [sortKey componentsSeparatedByString:@":"];
            if (sortComponents.count > 1) {
                NSNumber * customAscending = sortComponents.lastObject;
                ascending = customAscending.boolValue;
                sortKey = sortComponents[0];
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
            [sortDescriptors addObject:sortDescriptor];
        }
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSArray *results = [self MR_executeFetchRequest:fetchRequest inContext:context];
    
    return results;
}

///Added by Zhoucy  2015-8-5 23:02
+ (NSArray *)MR_aggregateOperation:(NSString *)collectionOperator onAttributes:(NSArray *)attributeNames withPredicate:(NSPredicate *)predicate groupBy:(NSArray *)groupingKeyPaths HavingPredicate:(NSPredicate *)havingPredicate SortTerm:(NSString *)sortTerm Ascending:(BOOL)ascending FetchLimit:(NSUInteger)fetchLimit {
    return [self MR_aggregateOperation:collectionOperator onAttributes:attributeNames withPredicate:predicate groupBy:groupingKeyPaths HavingPredicate:havingPredicate  SortTerm:sortTerm Ascending:ascending FetchLimit:fetchLimit inContext:[NSManagedObjectContext MR_defaultContext]];
}


+ (NSArray *)MR_aggregateOperation:(NSString *)collectionOperator onAttributes:(NSArray *)attributeNames withPredicate:(NSPredicate *)predicate groupBy:(NSArray *)groupingKeyPaths {
     return [self MR_aggregateOperation:collectionOperator onAttributes:attributeNames withPredicate:predicate groupBy:groupingKeyPaths HavingPredicate:nil  SortTerm:@"" Ascending:YES FetchLimit:10000000 inContext:[NSManagedObjectContext MR_defaultContext]];
}





+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm FetchLimit:(NSUInteger)fetchLimit inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setFetchLimit:fetchLimit];
    
    return [self MR_executeFetchRequest:request
                              inContext:context];
}




@end
