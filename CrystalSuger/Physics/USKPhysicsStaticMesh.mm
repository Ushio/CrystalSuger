/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */
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
