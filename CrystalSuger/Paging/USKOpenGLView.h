//
//  MyGLView.h
//  FrameBufferObjectResearch
//
//  Created by yoshimura on 12/05/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>

@interface USKOpenGLView : UIView
- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context;

@property (nonatomic, readonly) int glBufferWidth;
@property (nonatomic, readonly) int glBufferHeight;

@property (nonatomic, readonly) GLuint framebuffer;
@property (nonatomic, readonly) GLuint colorRenderbuffer;
@property (nonatomic, readonly) GLuint depthRenderbuffer;

@end