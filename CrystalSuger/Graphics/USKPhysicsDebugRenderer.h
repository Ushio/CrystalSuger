/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#pragma once

#import "USKCameraProtocol.h"
#import "GStateManager.h"

#include "btBulletDynamicsCommon.h"
#include <vector>

typedef struct
{
    GLKVector3 position;
    GLKVector4 color;
}LineVertex;

class USKPhysicsDebugRenderer : public btIDebugDraw
{
public:
    USKPhysicsDebugRenderer();
    ~USKPhysicsDebugRenderer();
    
    virtual void drawLine(const btVector3& from,const btVector3& to,const btVector3& color);
    virtual void drawContactPoint(const btVector3& PointOnB,const btVector3& normalOnB,btScalar distance,int lifeTime,const btVector3& color);
	virtual void reportErrorWarning(const char* warningString);
	virtual void draw3dText(const btVector3& location,const char* textString);
	virtual void setDebugMode(int debugMode);
	virtual int getDebugMode()const;
    
    void draw(id<USKCameraProtocol> camera, GStateManager *sm);
private:
    int m_debugMode;
    id m_lineShader;
    std::vector<LineVertex> m_vertices;
};
