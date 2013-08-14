//
//  GMutableFbo.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/20.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "GMutableVbo.h"

/*
 GL_STATIC_DRAW 変えない
 GL_STREAM_DRAW １フレに１回書き換える
 GL_DYNAMIC_DRAW マルチパスなどで１フレに何度も書き換える
 
 用途を考えて、ひとまずGL_STREAM_DRAWで十分
 */
@implementation GMutableVbo
- (id)initWithBytes:(const void *)bytes size:(int)size type:(GVboType)type
{
    if(self = [super init])
    {
        _target = (type == GVBO_VERTEX)? GL_ARRAY_BUFFER : GL_ELEMENT_ARRAY_BUFFER;
        _size = size;
        
        glGenBuffers(1, &_buffer);
        glBindBuffer(_target, _buffer);
        glBufferData(_target, _size, bytes, GL_STREAM_DRAW);
        glBindBuffer(_target, 0);
    }
    return self;
}
- (void)map:(void(^)(void *pLocked))scope
{
    glBindBuffer(_target, _buffer);
    void *pLocked = glMapBufferOES(_target, GL_WRITE_ONLY_OES);
    if(scope)
        scope(pLocked);
    glUnmapBufferOES(_target);
    glBindBuffer(_target, 0);
}
@end
