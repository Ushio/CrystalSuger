/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "GMutableVbo.h"

/*
 GL_STATIC_DRAW 
 GL_STREAM_DRAW once modify per frame
 GL_DYNAMIC_DRAW multiple modify per frame
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
