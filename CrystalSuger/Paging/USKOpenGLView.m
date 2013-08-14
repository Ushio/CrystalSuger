//
//  MyGLView.m
//  FrameBufferObjectResearch
//
//  Created by yoshimura on 12/05/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

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
    
    unsigned status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"failed create framebuffer");
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
