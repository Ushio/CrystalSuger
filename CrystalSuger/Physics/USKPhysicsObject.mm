//
//  USKPhysicsObject.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPhysicsObject.h"

#import "USKPhysicsWorld.h"
#include "btBulletDynamicsCommon.h"

@implementation USKPhysicsObject
- (id)init
{
    if(self = [super init])
    {
        _userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)dealloc
{
    delete (btMotionState *)_motionState;
    delete (btRigidBody *)_body;
}
- (void)removeFromWorld
{
    btDynamicsWorld *dynamicsWorld = (btDynamicsWorld *)_dynamicsWorld;
    dynamicsWorld->removeRigidBody((btRigidBody *)_body);
    NSMutableSet *USKPhysicsObjects = [self.world valueForKey:@"_physicsObject"];
    [USKPhysicsObjects removeObject:self];
}
@end
