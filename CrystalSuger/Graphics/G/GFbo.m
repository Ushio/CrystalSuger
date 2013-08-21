/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "GFbo.h"

@implementation GFbo
{
    int _width, _height;
    
    GLuint _frameBuffer;
    GLuint _texture;
    GLuint _depthRenderBuffer;
}
- (id)initWithWidth:(int)width height:(int)height
{
    if(self = [super init])
    {
        int max_size = 0;
        glGetIntegerv(GL_MAX_RENDERBUFFER_SIZE, &max_size);
        
        NSAssert(0 < width && width <= max_size, @"");
        NSAssert(0 < height && height <= max_size, @"");
        
        _width = width;
        _height = height;

        //save
        GLuint currentFrameBuffer;
        GLuint currentRenderBuffer;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, (int *)&currentFrameBuffer);
        glGetIntegerv(GL_RENDERBUFFER_BINDING, (int *)&currentRenderBuffer);
                
        //texture
        GLuint currentTextureBinding;
        glGetIntegerv(GL_TEXTURE_BINDING_2D, (int *)&currentTextureBinding);
        
        glGenTextures(1, &_texture);
        glBindTexture(GL_TEXTURE_2D, _texture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        glBindTexture(GL_TEXTURE_2D, currentTextureBinding);
        
        //depth buffer
        glGenRenderbuffers(1, &_depthRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _width, _height);
        
        //framebuffer
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture, 0);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
                
        if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSAssert(0, @"failed create framebuffer");
        }
        
        //restore
        glBindRenderbuffer(GL_RENDERBUFFER, currentRenderBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
    }
    return self;
}
- (void)dealloc
{
    glDeleteFramebuffers(1, &_frameBuffer);
    glDeleteRenderbuffers(1, &_depthRenderBuffer);
    glDeleteTextures(1, &_texture);
}
- (void)bind:(void(^)(void))drawing
{
    //save
    GLuint currentFrameBuffer;
    GLuint currentRenderBuffer;
    int currentViewport[4];
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, (int *)&currentFrameBuffer);
    glGetIntegerv(GL_RENDERBUFFER_BINDING, (int *)&currentRenderBuffer);
    glGetIntegerv(GL_VIEWPORT, currentViewport);
    
    //viewport
    glViewport(0, 0, _width, _height);
    
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

    if(drawing)
        drawing();
    
    //restore
    glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, currentRenderBuffer);
    glViewport(currentViewport[0], currentViewport[1], currentViewport[2], currentViewport[3]);
}

- (GLuint)texture
{
    return _texture;
}
- (int)width
{
    return _width;
}
- (int)height
{
    return _height;
}
@end
