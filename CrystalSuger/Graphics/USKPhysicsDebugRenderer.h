//
//  USKPhysicsDebugRenderer.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#ifndef __CrystalSuger__USKPhysicsDebugRenderer__
#define __CrystalSuger__USKPhysicsDebugRenderer__

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


#endif
