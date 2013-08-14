//
//  USKFactoryPage.h
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/13.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USKModelManager.h"

@interface USKFactoryPageController : NSObject
@property (strong, nonatomic, readonly) UIView *view;
- (id)initWithSize:(CGSize)size modelManager:(USKModelManager *)modelManager;
@end
