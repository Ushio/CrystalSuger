//
//  NSManagedObject+Helper.m
//  DocumentStudy
//
//  Created by 吉村 篤 on 2013/03/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "NSManagedObject+Helper.h"

@implementation NSManagedObject (Helper)
+ (id)createInstanceWithContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
}
- (void)destroyInstance
{
    [self.managedObjectContext deleteObject:self];
}

+ (NSArray *)fetchWithContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    request.predicate = predicate;
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if(error)
    {
        NSLog(@"%@", error);
        return @[];
    }
    return result;
}
@end
