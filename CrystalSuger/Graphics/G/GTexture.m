/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "GTexture.h"
#import <GLKit/GLKit.h>

@implementation GTexture
{
    unsigned _name;
}
- (unsigned)name { return _name; }

- (id)initWithContentsOfFile:(NSString *)path
               interpolation:(int)interpolation
                        wrap:(int)wrap
{
    if(self = [super init])
    {
        NSError *error;
        GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path
                                                                   options:nil
                                                                     error:&error];
        NSAssert(error == nil, @"");
        _name = info.name;
        
        glBindTexture(GL_TEXTURE_2D, _name);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, interpolation);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, interpolation);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap);
    }
    return self;
}
- (id)initWithCGImage:(CGImageRef)image
        interpolation:(int)interpolation
                 wrap:(int)wrap
{
    if(self = [super init])
    {
        NSError *error;
        GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:image
                                                            options:nil
                                                              error:&error];
        NSAssert(error == nil, @"");
        _name = info.name;
        
        glBindTexture(GL_TEXTURE_2D, _name);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, interpolation);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, interpolation);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap);
    }
    return self;
}
- (void)dealloc
{
    glDeleteTextures(1, &_name);
}
@end
