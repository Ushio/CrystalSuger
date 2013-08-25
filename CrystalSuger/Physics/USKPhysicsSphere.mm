/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

#import "USKPhysicsSphere.h"

#include "btBulletDynamicsCommon.h"

static const btScalar kMass = 1.0f;
static btSphereShape kSphereShape(0.0725);

@implementation USKPhysicsSphere
- (id)initWithPosition:(GLKVector3)position
{
    if(self = [super init])
    {
        btTransform defaultTransform;
        defaultTransform.setIdentity();
        defaultTransform.setOrigin(btVector3(position.x, position.y, position.z));
        btMotionState *motionState = new btDefaultMotionState(defaultTransform);
        _motionState = motionState;
        
        btVector3 localInertia;
        kSphereShape.calculateLocalInertia(kMass, localInertia);
        btRigidBody::btRigidBodyConstructionInfo info(kMass, motionState, &kSphereShape, localInertia);
        btRigidBody *body = new btRigidBody(info);
        body->setActivationState(DISABLE_DEACTIVATION);
        _body = body;
    }
    return self;
}
- (id)init
{
    return [self initWithPosition:GLKVector3Make(0, 0, 0)];
}
- (void)setPosition:(GLKVector3)position
{
    btMotionState *motionState = (btMotionState *)_motionState;
    btTransform current;
    motionState->getWorldTransform(current);
    current.setOrigin(btVector3(position.x, position.y, position.z));
    motionState->setWorldTransform(current);
    
    btRigidBody *body = (btRigidBody *)_body;
    body->setMotionState(motionState);
}
- (GLKVector3)position
{
    btMotionState *motionState = (btMotionState *)_motionState;
    btTransform current;
    motionState->getWorldTransform(current);
    return GLKVector3Make(current.getOrigin().x(), current.getOrigin().y(), current.getOrigin().z());
}
- (void)setRotation:(GLKQuaternion)rotation
{
    btMotionState *motionState = (btMotionState *)_motionState;
    btTransform current;
    motionState->getWorldTransform(current);
    current.setRotation(btQuaternion(rotation.x, rotation.y, rotation.z, rotation.w));
    motionState->setWorldTransform(current);
    
    btRigidBody *body = (btRigidBody *)_body;
    body->setMotionState(motionState);
}
- (GLKQuaternion)rotation
{
    btMotionState *motionState = (btMotionState *)_motionState;
    btTransform current;
    motionState->getWorldTransform(current);
    btQuaternion rot = current.getRotation();
    return GLKQuaternionMake(rot.x(), rot.y(), rot.z(), rot.w());
}
@end
