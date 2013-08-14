//
//  StarRenderer.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/17.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"

@interface USKStarRenderer : NSObject
- (void)renderAtTime:(double)time aspect:(float)aspect sm:(GStateManager *)sm;
@end
