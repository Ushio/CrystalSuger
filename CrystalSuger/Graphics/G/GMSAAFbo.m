//
//  GMSAAFbo.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/15.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

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
