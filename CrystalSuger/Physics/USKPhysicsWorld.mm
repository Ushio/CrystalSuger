//
//  Physic.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPhysicsWorld.h"

#import "USKUtility.h"

#include "btBulletDynamicsCommon.h"
#include "USKPhysicsDebugRenderer.h"

#import "USKPhysicsObject.h"
#import "USKPhysicsSphere.h"
#import "USKPhysicsStaticMesh.h"

#include <string>

@implementation USKPhysicsWorld
{
    btDefaultCollisionConfiguration *_configration;
    btCollisionDispatcher *_dispatcher;
    btSequentialImpulseConstraintSolver *_solver;
    btBroadphaseInterface *_broadphase;
    btDynamicsWorld *_world;
    
    USKPhysicsDebugRenderer *_debug;
    
    NSMutableSet *_physicsObject;
}
- (id)init
{
    if(self = [super init])
    {
        _configration = new btDefaultCollisionConfiguration();
        _dispatcher = new btCollisionDispatcher(_configration);
        _solver = new btSequentialImpulseConstraintSolver();
        
        const float size = 1.0f;
        btVector3 aabbMin(-size, -size, -size);
        btVector3 aabbMax(size, size, size);
        _broadphase = new btAxisSweep3(aabbMin, aabbMax, 101);
        _world = new btDiscreteDynamicsWorld(_dispatcher, _broadphase,_solver, _configration);
        
        _world->setGravity(btVector3(0, -9.8f, 0));
        
        _debug = new USKPhysicsDebugRenderer();
        _debug->setDebugMode(btIDebugDraw::DBG_DrawWireframe);
        _world->setDebugDrawer(_debug);
        
        _physicsObject = [NSMutableSet set];
    }
    return self;
}
- (void)dealloc
{
    for (int i = _world->getNumCollisionObjects() - 1; i >= 0 ; --i)
	{
		_world->removeCollisionObject( _world->getCollisionObjectArray()[i] );
	}
    
    delete _world;
    delete _broadphase;
    delete _solver;
    delete _dispatcher;
    delete _configration;
    
    delete _debug;
}
- (void)setGravity:(GLKVector3)gravity
{
    _world->setGravity(btVector3(gravity.x, gravity.y, gravity.z));
}
- (void)stepWithDeltaTime:(double)deltaTime
{
    _world->stepSimulation(deltaTime, 1, 1.0 / 60.0);
}
- (void)renderForDebug:(GStateManager *)stateManager camera:(id<USKCameraProtocol>)camera
{
    _world->debugDrawWorld();
    _debug->draw(camera, stateManager);
}
- (void)addPhysicsObject:(USKPhysicsObject *)object
{
    NSAssert([_physicsObject containsObject:object] == NO, @"重複挿入");
    [_physicsObject addObject:object];
    
    object->_dynamicsWorld = _world;
    _world->addRigidBody((btRigidBody *)object->_body);
    object.world = self;
}
@end
