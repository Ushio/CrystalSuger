/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

#import "GMSAAFbo.h"

#import <OpenGLES/ES2/gl.h>

@implementation GMSAAFbo
{
    unsigned _multisampleFrameBuffer;
    unsigned _multisampleColorRenderBuffer;
    unsigned _multisampleDepthRenderBuffer;
}
- (id)initWithWidth:(int)width height:(int)height
{
    if(self = [super initWithWidth:width height:height])
    {   
        //save
        GLuint currentFrameBuffer;
        GLuint currentRenderBuffer;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, (int *)&currentFrameBuffer);
        glGetIntegerv(GL_RENDERBUFFER_BINDING, (int *)&currentRenderBuffer);
        
        glGenRenderbuffers(1, &_multisampleColorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _multisampleColorRenderBuffer);
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, width, height);
        
        glGenRenderbuffers(1, &_multisampleDepthRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _multisampleDepthRenderBuffer);
        glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH24_STENCIL8_OES, width, height);
        
        glGenFramebuffers(1, &_multisampleFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _multisampleFrameBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _multisampleColorRenderBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _multisampleDepthRenderBuffer);
        
        if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSAssert(0, @"");
        }
        
        //restore
        glBindRenderbuffer(GL_RENDERBUFFER, currentRenderBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
    }
    return self;
}
- (void)dealloc
{
    glDeleteFramebuffers(1, &_multisampleFrameBuffer);
    glDeleteRenderbuffers(1, &_multisampleColorRenderBuffer);
    glDeleteRenderbuffers(1, &_multisampleDepthRenderBuffer);
}
- (void)bind:(void (^)(void))drawing
{
    [super bind:^{
        glBindFramebuffer(GL_FRAMEBUFFER, _multisampleFrameBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _multisampleColorRenderBuffer);
        
        if(drawing)
            drawing();
        
        GLuint framebuffer = [[self valueForKey:@"_frameBuffer"] unsignedIntValue];
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, framebuffer);
        glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _multisampleFrameBuffer);
        glResolveMultisampleFramebufferAPPLE();
        const GLenum discards[]  = {GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT};
        glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, discards);
    }];
}
@end
