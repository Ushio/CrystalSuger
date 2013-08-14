//
//  USKPage.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class USKKompeito, USKRoot;

@interface USKPage : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *kompeitos;
@property (nonatomic, retain) USKRoot *root;
@end

@interface USKPage (CoreDataGeneratedAccessors)

- (void)addKompeitosObject:(USKKompeito *)value;
- (void)removeKompeitosObject:(USKKompeito *)value;
- (void)addKompeitos:(NSSet *)values;
- (void)removeKompeitos:(NSSet *)values;

@end
