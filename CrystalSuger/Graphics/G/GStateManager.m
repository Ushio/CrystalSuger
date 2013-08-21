/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


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