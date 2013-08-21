/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

#import "USKOpenGLView.h"

#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

@interface USKOpenGLView()
@property (nonatomic) int glBufferWidth;
@property (nonatomic) int glBufferHeight;

@property (nonatomic) GLuint framebuffer;
@property (nonatomic) GLuint colorRenderbuffer;
@property (nonatomic) GLuint depthRenderbuffer;
@end

@implementation USKOpenGLView
{
    EAGLContext *_context;
}

+ (Class) layerClass { return [CAEAGLLayer class]; }
- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _context = context;
        
        //setup opengl layer
        CAEAGLLayer *glLayer = (CAEAGLLayer *)self.layer;
        glLayer.contentsScale = [UIScreen mainScreen].scale;
        glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @NO,
                                       kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
        glLayer.opaque = YES;
        
        [self setupFrameBuffer];
    }
    return self;
}
- (void)dealloc
{
    [EAGLContext setCurrentContext:_context];
    [self shutdownFrameBuffer];
}
- (int)glBufferWidth { return _glBufferWidth; }
- (int)glBufferHeight { return _glBufferHeight; }

- (void)setupFrameBuffer
{
    if(_framebuffer)
        return;
    
    [EAGLContext setCurrentContext:_context];
    
    //レンダーバッファ
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(id<EAGLDrawable>)self.layer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_glBufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_glBufferHeight);
    
    glGenRenderbuffers(1, &_depthRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24_OES, _glBufferWidth, _glBufferHeight);
    
    //フレームバッファ
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderbuffer);
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSAssert(0, @"failed create framebuffer");
    }
}
- (void)shutdownFrameBuffer
{
    [EAGLContext setCurrentContext:_context];
    
    if(_framebuffer)
    {
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }
    if(_colorRenderbuffer)
    {
        glDeleteRenderbuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
    if(_depthRenderbuffer)
    {
        glDeleteRenderbuffers(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
}
- (void)layoutSubviews
{
    [self shutdownFrameBuffer];
    [self setupFrameBuffer];
}
//- (void)render:(CADisplayLink *)sender 
//{
//    [self.glViewDelegate render:sender];
//
//    [mainContext presentRenderbuffer:GL_RENDERBUFFER];
//}
@end
