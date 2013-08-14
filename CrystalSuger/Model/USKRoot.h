//
//  USKRoot.h
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/13.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class USKPage;

@interface USKRoot : NSManagedObject

@property (nonatomic, retain) NSSet *pages;
@end

@interface USKRoot (CoreDataGeneratedAccessors)

- (void)addPagesObject:(USKPage *)value;
- (void)removePagesObject:(USKPage *)value;
- (void)addPages:(NSSet *)values;
- (void)removePages:(NSSet *)values;

@end
