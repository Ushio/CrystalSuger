//
//  GFbo.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/20.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "GVbo.h"

@implementation GVbo
- (id)initWithBytes:(const void *)bytes size:(int)size type:(GVboType)type
{
    if(self = [super init])
    {
        _target = (type == GVBO_VERTEX)? GL_ARRAY_BUFFER : GL_ELEMENT_ARRAY_BUFFER;
        _size = size;
        
        glGenBuffers(1, &_buffer);
        glBindBuffer(_target, _buffer);
        glBufferData(_target, _size, bytes, GL_STATIC_DRAW);
        glBindBuffer(_target, 0);
    }
    return self;
}
- (void)dealloc
{
    glDeleteBuffers(1, &_buffer);
    _buffer = 0;
}
- (GLuint)vbo
{
    return _buffer;
}
- (int)size
{
    return _size;
}
- (void)bind:(void(^)(void))blocks
{
    glBindBuffer(_target, _buffer);
    
    if(blocks)
        blocks();
    
    glBindBuffer(_target, 0);
}
@end
