//
//  Physic.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
#import "USKCameraProtocol.h"
#import "USKPhysicsObject.h"

@interface USKPhysicsWorld : NSObject
- (void)stepWithDeltaTime:(double)deltaTime;
- (void)renderForDebug:(GStateManager *)stateManager camera:(id<USKCameraProtocol>)camera;

@property (nonatomic, assign) GLKVector3 gravity;

- (void)addPhysicsObject:(USKPhysicsObject *)object;
@end