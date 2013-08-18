//
//  USKAddParticleSystem.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/18.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "GStateManager.h"
#import "USKCameraProtocol.h"

@interface USKAddParticleSystem : NSObject
- (void)addWithPosition:(GLKVector3)position color:(GLKVector3)color;
- (void)stepWithDelta:(double)delta;
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm;
@end
