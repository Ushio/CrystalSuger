//
//  USKPhysicsSphere.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPhysicsSphere.h"

#include "btBulletDynamicsCommon.h"

static const btScalar kMass = 1.0f;
static btSphereShape kSphereShape(0.07);

@implementation USKPhysicsSphere
- (id)init
{
    if(self = [super init])
    {
        btTransform defaultTransform;
        defaultTransform.setIdentity();
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
