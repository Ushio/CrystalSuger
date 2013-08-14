//
//  USKPostEffect.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/05/24.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
@interface USKPostEffect : NSObject
- (void)renderWithTexture:(GLuint)texture sm:(GStateManager *)sm;
@end
