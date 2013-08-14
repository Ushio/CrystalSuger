//
//  NSManagedObject+Helper.h
//  DocumentStudy
//
//  Created by 吉村 篤 on 2013/03/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)
+ (id)createInstanceWithContext:(NSManagedObjectContext *)context;
- (void)destroyInstance;

+ (NSArray *)fetchWithContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;
@end
