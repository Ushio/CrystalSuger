//
//  USKPhysicsStaticMesh.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPhysicsStaticMesh.h"

#include "btBulletDynamicsCommon.h"

@implementation USKPhysicsStaticMesh
{
    btTriangleMesh *_mesh;
    btBvhTriangleMeshShape *_shape;
}
- (id)initWithTriMesh:(const GLKVector3 *)mesh numberOfVertices:(int)numberOfVertices
{
    if(self = [super init])
    {
        //テスト瓶
        _mesh = new btTriangleMesh();
        for(int i = 0 ; i < numberOfVertices ; i += 3)
        {
            btVector3 v0(mesh[i].x, mesh[i].y, mesh[i].z);
            btVector3 v1(mesh[i+1].x, mesh[i+1].y, mesh[i+1].z);
            btVector3 v2(mesh[i+2].x, mesh[i+2].y, mesh[i+2].z);
            _mesh->addTriangle(v0, v1, v2);
        }
        _shape = new btBvhTriangleMeshShape(_mesh, true, true);
        btTransform defaultTransform;
        defaultTransform.setIdentity();
        btMotionState *motionState = new btDefaultMotionState(defaultTransform);
        _motionState = motionState;
        
        btRigidBody::btRigidBodyConstructionInfo info(0.0, motionState, _shape, btVector3(0.0f, 0.0f, 0.0f));
        _body = new btRigidBody(info);
    }
    return self;
}
- (void)dealloc
{
    delete _shape;
    delete _mesh;
}
@end
