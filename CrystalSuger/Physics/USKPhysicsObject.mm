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

#include <string>

@implementation USKPhysicsObject
- (void)dealloc
{
#if DEBUG
    btDynamicsWorld *dynamicsWorld = static_cast<btDynamicsWorld *>(_dynamicsWorld);
    for (int i = dynamicsWorld->getNumCollisionObjects() - 1; i >= 0 ; --i)
	{
		btRigidBody *rigidBody = dynamic_cast<btRigidBody *>(dynamicsWorld->getCollisionObjectArray()[i]);
        NSAssert(rigidBody != _body, @"");
	}
#endif
    
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
- (void)aabbMin:(GLKVector3 *)min max:(GLKVector3 *)max
{
    btRigidBody *body = static_cast<btRigidBody *>(_body);
    btVector3 aabbMin, aabbMax;
    body->getAabb(aabbMin, aabbMax);
    
    *min = GLKVector3Make(aabbMin.x(), aabbMin.y(), aabbMin.z());
    *max = GLKVector3Make(aabbMax.x(), aabbMax.y(), aabbMax.z());
}
@end
