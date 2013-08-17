//
//  USKPostEffect.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/05/24.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPostEffect.h"

#import "GMacros.h"
#import "GShader.h"
#import "USKSpliteVertices.h"
#import "GVao.h"
#import "GVbo.h"

@implementation USKPostEffect
{
    GShader *_shader;
    GVbo *_vbo;
    GVao *_vao;
    GState *_state;
}
- (id)init
{
    if(self = [super init])
    {
        NSString *vs = SHADER_STRING(
                                     attribute vec4 a_position;
                                     attribute vec2 a_texcoord;
                                     
                                     varying highp vec2 v_uv;
                                     void main()
                                     {
                                         v_uv = vec2(a_texcoord.x, 1.0 - a_texcoord.y);
                                         gl_Position = a_position;
                                     }
                                     );
        NSString *fs = SHADER_STRING(
                                     uniform sampler2D u_image;
                                     varying highp vec2 v_uv;
                                     
                                     const lowp float contrast = 1.3;
                                     
                                     void main()
                                     {
                                         gl_FragColor.rgb = (texture2D(u_image, v_uv).rgb - vec3(0.5, 0.5, 0.5)) * contrast + vec3(0.5, 0.5, 0.5);
                                     }
                                     );
        NSError *error;
        _shader = [[GShader alloc] initWithVertexShader:vs fragmentShader:fs error:&error];
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
- (void)renderWithTexture:(GLuint)texture sm:(GStateManager *)sm
{
    sm.currentState = _state;
    
    sm.activeTexture = GL_TEXTURE0;
    glBindTexture(GL_TEXTURE_2D, texture);
    [_shader bind:^{
        [_shader setTextureUnit:0 forUniformKey:@"u_image"];
        
        [_vao bind:^{
            glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
        }];
    }];
}
@end
