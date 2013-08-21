/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "GState.h"

@implementation GState
- (id)init
{
    if(self = [super init])
    {
        self.blend = NO;
        self.blend_sfactor = GL_ONE;
        self.blend_dfactor = GL_ZERO;
        
        self.depthTest = NO;
        self.depthWrite = YES;
        
        self.cullFace = NO;
        self.cullFaceMode = GL_BACK;
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    GState *copy = [GState new];
    
    copy.blend = self.blend;
    copy.blend_sfactor = self.blend_sfactor;
    copy.blend_dfactor = self.blend_dfactor;
    
    copy.depthTest = self.depthTest;
    copy.depthWrite = self.depthWrite;
    
    copy.cullFace = self.cullFace;
    copy.cullFaceMode = self.cullFaceMode;
    
    return copy;
}
@end


