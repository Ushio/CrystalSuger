//
//  USKPage.h
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/13.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class USKRoot;

@interface USKPage : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) USKRoot *root;

@end
