//
//  StarRenderer.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/17.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKStarRenderer.h"

#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "USKUtility.h"
#import "GVbo.h"

#import "GVao.h"

static const int kNumberOfStar = 2000;
static const float kDepth = 8.0f;
static const float kWidth = 4.0;
static const float kHeight = 4.0;

static const float kSpeed = 0.5f;

typedef struct
{
    GLKVector3 position;
}vertex_t;

@implementation USKStarRenderer
{
    GTexture *_starTexture;
    GShader *_shader;
    GState *_state;
    
    GVao *_vao;
    GVbo *_vbo;
}
- (id)init
{
    if(self = [super init])
    {
        _state = [GState new];
        _state.blend = YES;
        _state.blend_sfactor = GL_SRC_ALPHA;
        _state.blend_dfactor = GL_ONE;
        _state.depthWrite = NO;
        
        NSString *backgroundPath = [[NSBundle mainBundle] pathForResource:@"star.png" ofType:@""];
        _starTexture = [[GTexture alloc] initWithContentsOfFile:backgroundPath
                                                interpolation:GL_LINEAR
                                                         wrap:GL_CLAMP_TO_EDGE];
        
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform mat4 u_transform;
                                            uniform float u_offset;
                                            attribute vec4 a_position;
                                            
                                            varying float v_alpha;
                                            
                                            const float k_repeat = -8.0;
                                            void main()
                                            {
                                                vec4 offseted = vec4(a_position.xy, mod(a_position.z + u_offset, k_repeat), 1.0);
                                                vec4 transformed = u_transform * offseted;
                                                gl_Position = transformed;
                                                
                                                gl_PointSize = 30.0 / transformed.w;
                                                v_alpha = min(offseted.z - k_repeat, 1.0);
                                            }
                                            );
        NSString *const kFS = SHADER_STRING(
                                            varying lowp float v_alpha;
                                            uniform sampler2D u_image;
                                            void main()
                                            {
                                                gl_FragColor.rgb = texture2D(u_image, gl_PointCoord).rgb;
                                                gl_FragColor.a = v_alpha;
                                            }
                                            );
        _shader = [[GShader alloc] initWithVertexShader:kVS fragmentShader:kFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        vertex_t *vertices = malloc(sizeof(vertex_t) * kNumberOfStar);
        for(int i = 0 ; i < kNumberOfStar ; ++i)
        {
            float x = [USKUtility remapValue:rand() iMin:0 iMax:RAND_MAX oMin:-kWidth * 0.5f oMax:kWidth * 0.5f];
            float y = [USKUtility remapValue:rand() iMin:0 iMax:RAND_MAX oMin:-kHeight * 0.5f oMax:kHeight * 0.5f];
            float z = [USKUtility remapValue:rand() iMin:0 iMax:RAND_MAX oMin:0 oMax:-kDepth];
            
            vertices[i].position = GLKVector3Make(x, y, z);
        }
        _vbo = [[GVbo alloc] initWithBytes:vertices size:sizeof(vertex_t) * kNumberOfStar type:GVBO_VERTEX];
        free(vertices);
        vertices = NULL;
        
        _vao = [GVao new];
        [_vao bind:^{
            [_vbo bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), (char *)0 + offsetof(vertex_t, position));
                glEnableVertexAttribArray(a_position);
            }];
        }];
    }
    return self;
}

- (void)renderAtTime:(double)time aspect:(float)aspect sm:(GStateManager *)sm
{
    sm.currentState = _state;
    
    GLKMatrix4 proj = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), aspect, 0.1f, 100.0f);
    GLKMatrix4 view = GLKMatrix4MakeLookAt(0, 0, 0, 0, 0, -1.0, 0, 1, 0);
    GLKMatrix4 transform = GLKMatrix4Multiply(proj, view);

    sm.activeTexture = GL_TEXTURE0;
    glBindTexture(GL_TEXTURE_2D, [_starTexture name]);
    [_shader bind:^{
        [_shader setTextureUnit:0 forUniformKey:@"u_image"];
        [_shader setMatrix4:transform forUniformKey:@"u_transform"];
        [_shader setFloat:time * kSpeed forUniformKey:@"u_offset"];
        
        [_vao bind:^{
            glDrawArrays(GL_POINTS, 0, kNumberOfStar);
        }];
    }];
}
@end
