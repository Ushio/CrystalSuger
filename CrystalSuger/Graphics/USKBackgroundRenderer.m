//
//  GBackground.m
//  iCrystalSuger
//
//  Created by 吉村 篤 on 2013/03/31.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKBackgroundRenderer.h"
#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "USKUtility.h"
#import "USKSpliteShader.h"
#import "USKSpliteVertices.h"
#import "GVao.h"
#import "GVbo.h"

@implementation USKBackgroundRenderer
{
    GTexture *_background;
    GShader *_shader;
    GVbo *_vbo;
    GVao *_vao;
    GState *_state;
}
- (id)init
{
    if(self = [super init])
    {
        NSString *backgroundPath = [[NSBundle mainBundle] pathForResource:@"background.pvrtc" ofType:@""];
        _background = [[GTexture alloc] initWithContentsOfFile:backgroundPath
                                                interpolation:GL_NEAREST
                                                         wrap:GL_CLAMP_TO_EDGE];
        NSError *error;
        _shader = [[GShader alloc] initWithVertexShader:kSpliteVS fragmentShader:kSpliteFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        typedef struct{
            GLKVector2 position;
            GLKVector2 texcoord;
        }Vertex;
        
        _vbo = [[GVbo alloc] initWithBytes:spliteVertices size:sizeof(spliteVertices) type:GVBO_VERTEX];
        
        _vao = [GVao new];
        [_vao bind:^{
            [_vbo bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                int a_texcoord = [_shader attribLocationForKey:@"a_texcoord"];
                glVertexAttribPointer(a_position, 2, GL_FLOAT, GL_FALSE, sizeof(SpliteVertex), (char *)0 + offsetof(SpliteVertex, position));
                glVertexAttribPointer(a_texcoord, 2, GL_FLOAT, GL_FALSE, sizeof(SpliteVertex), (char *)0 + offsetof(SpliteVertex, texcoord));
                glEnableVertexAttribArray(a_position);
                glEnableVertexAttribArray(a_texcoord);
            }];
        }];
        
        _state = [GState new];
        _state.depthWrite = NO;
    }
    return self;
}

- (void)renderWithAspect:(float)aspect sm:(GStateManager *)sm
{
    sm.currentState = _state;
    
    GLKMatrix4 transform = GLKMatrix4MakeOrtho(-1.0f, 1.0f, -1.0f / aspect, 1.0f / aspect, 1, -1);
    
    sm.activeTexture = GL_TEXTURE0;
    glBindTexture(GL_TEXTURE_2D, [_background name]);
    [_shader bind:^{
        [_shader setTextureUnit:0 forUniformKey:@"u_image"];
        [_shader setMatrix4:transform forUniformKey:@"u_transform"];
        
        [_vao bind:^{
            glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
        }];
    }];
}
@end
