//
//  GStateManager.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/21.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

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


