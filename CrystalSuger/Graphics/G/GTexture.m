//
//  GTexture.m
//  iCrystalSuger
//
//  Created by 吉村 篤 on 2013/03/31.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

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
