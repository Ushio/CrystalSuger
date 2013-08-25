/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

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
