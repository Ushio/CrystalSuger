//
//  GVao.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "GVao.h"

@implementation GVao
{
    GLuint _vao;
}
- (id)init
{
    if(self = [super init])
    {
        glGenVertexArraysOES(1, &_vao);
    }
    return self;
}
- (void)dealloc
{
    glDeleteBuffers(1, &_vao);
}
- (void)bind:(void(^)(void))blocks
{
    glBindVertexArrayOES(_vao);
    
    if(blocks)
        blocks();
    
    glBindVertexArrayOES(0);
}
@end
