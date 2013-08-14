//
//  GBackground.h
//  iCrystalSuger
//
//  Created by 吉村 篤 on 2013/03/31.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
@interface USKBackgroundRenderer : NSObject
- (void)renderWithAspect:(float)aspect sm:(GStateManager *)sm;
@end
