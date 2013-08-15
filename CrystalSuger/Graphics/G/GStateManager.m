//
//  GStateManager.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/05/24.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "GStateManager.h"

@implementation GStateManager
{
    GState *_current;
    GLenum _activeTexture;
}
- (id)init
{
    if(self = [super init])
    {
        _current = [GState new];
        _clearColor = GLKVector4Make(0, 0, 0, 0);
    }
    return self;
}

- (void)setCurrentState:(GState *)newState
{
    if(newState == nil)
        newState = [GState new];
    
    if(_current.blend != newState.blend)
    {
        if(newState.blend)
        {
            glEnable(GL_BLEND);
        }
        else
        {
            glDisable(GL_BLEND);
        }
    }
    
    if(_current.blend_sfactor != newState.blend_sfactor || _current.blend_dfactor != newState.blend_dfactor)
    {
        glBlendFunc(newState.blend_sfactor, newState.blend_dfactor);
    }
    
    if(_current.depthTest != newState.depthTest)
    {
        if(newState.depthTest)
        {
            glEnable(GL_DEPTH_TEST);
        }
        else
        {
            glDisable(GL_DEPTH_TEST);
        }
    }
    
    if(_current.depthWrite != newState.depthWrite)
    {
        glDepthMask(newState.depthWrite? GL_TRUE : GL_FALSE);
    }
    
    if(_current.cullFace != newState.cullFace)
    {
        if(newState.cullFace)
        {
            glEnable(GL_CULL_FACE);
        }
        else
        {
            glDisable(GL_CULL_FACE);
        }
    }
    if(_current.cullFaceMode != newState.cullFaceMode)
    {
        glCullFace(newState.cullFaceMode);
    }
    
    _current = [newState copy];
}

- (void)setClearColor:(GLKVector4)clearColor
{
    for(int i = 0 ; i < 4 ; ++i)
    {
        if(ABS(_clearColor.v[i] - clearColor.v[i]) > FLT_EPSILON)
        {
            glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
            _clearColor = clearColor;
            return;
        }
    }
}

- (void)setActiveTexture:(GLenum)activeTexture
{
    if(_activeTexture != activeTexture)
    {
        _activeTexture = activeTexture;
        glActiveTexture(_activeTexture);
    }
}
- (GLenum)activeTexture
{
    return _activeTexture;
}

@end