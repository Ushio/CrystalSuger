//
//  USKKompeito.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class USKPage;

@interface USKKompeito : NSManagedObject

@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * z;
@property (nonatomic, retain) USKPage *page;

@end
