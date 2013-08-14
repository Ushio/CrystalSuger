//
//  USKPhysicsDebugRenderer.cpp
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#include "USKPhysicsDebugRenderer.h"

#import "GMacros.h"
#import "GShader.h"
#import <OpenGLES/ES2/gl.h>

USKPhysicsDebugRenderer::USKPhysicsDebugRenderer()
{
    NSError *error;
    NSString *const kLineShaderVS = SHADER_STRING(
                                                  uniform mat4 u_transform;
                                                  
                                                  attribute vec4 a_color;
                                                  attribute vec4 a_position;
                                                  
                                                  varying vec4 v_color;
                                                  void main()
                                                  {
                                                      gl_Position = u_transform * a_position;
                                                      v_color = a_color;
                                                  }
                                                  );
    NSString *const kLineShaderFS = SHADER_STRING(
                                                  precision highp float;
                                                  varying vec4 v_color;
                                                  void main()
                                                  {
                                                      gl_FragColor = v_color;
                                                  }
                                                  );
    m_lineShader = [[GShader alloc] initWithVertexShader:kLineShaderVS fragmentShader:kLineShaderFS error:&error];
    SHADER_ERROR_HANDLE(error);
}
USKPhysicsDebugRenderer::~USKPhysicsDebugRenderer()
{
    m_lineShader = nil;
}
void USKPhysicsDebugRenderer::drawLine(const btVector3& from,const btVector3& to,const btVector3& color)
{
    LineVertex v1 = {{from.x(), from.y(), from.z()}, {color.x(), color.y(), color.z(), 1.0f}};
    LineVertex v2 = {{to.x(), to.y(), to.z()}, {color.x(), color.y(), color.z(), 1.0f}};
    m_vertices.push_back(v1);
    m_vertices.push_back(v2);
}
void USKPhysicsDebugRenderer::drawContactPoint(const btVector3& PointOnB,const btVector3& normalOnB,btScalar distance,int lifeTime,const btVector3& color)
{
    //面倒
}
void USKPhysicsDebugRenderer::reportErrorWarning(const char* warningString)
{
    NSLog(@"reportErrorWarning");
}
void USKPhysicsDebugRenderer::draw3dText(const btVector3& location,const char* textString)
{
    //面倒
}
void USKPhysicsDebugRenderer::setDebugMode(int debugMode)
{
    m_debugMode = debugMode;
}
int USKPhysicsDebugRenderer::getDebugMode()const
{
    return m_debugMode;
}
void USKPhysicsDebugRenderer::draw(id<USKCameraProtocol> camera, GStateManager *sm)
{
    sm.currentState = nil;
    [m_lineShader bind:^{
        [m_lineShader setMatrix4:GLKMatrix4Multiply([camera proj], [camera view]) forUniformKey:@"u_transform"];
        
        LineVertex *head = m_vertices.data();
        int a_position = [m_lineShader attribLocationForKey:@"a_position"];
        int a_color = [m_lineShader attribLocationForKey:@"a_color"];
        glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(LineVertex), &head->position);
        glVertexAttribPointer(a_color, 4, GL_FLOAT, GL_FALSE, sizeof(LineVertex), &head->color);
        glEnableVertexAttribArray(a_position);
        glEnableVertexAttribArray(a_color);
        
        glDrawArrays(GL_LINES, 0, m_vertices.size());
        
        glDisableVertexAttribArray(a_position);
        glDisableVertexAttribArray(a_color);
    }];
    
    m_vertices.clear();
}
