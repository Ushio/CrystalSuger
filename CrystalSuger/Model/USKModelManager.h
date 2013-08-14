//
//  USKModelManager.h
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/13.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "USKPage.h"
#import "USKRoot.h"

@interface USKModelManager : NSObject
@property (strong, nonatomic, readonly) NSManagedObjectContext *context;
@property (strong, nonatomic, readonly) USKRoot *root;
- (void)save;
@end
