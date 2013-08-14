//
//  USKAddEffectRenderer.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/06/02.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKAddEffectRenderer.h"

#import "GMacros.h"
#import "GShader.h"
#import "USKAddEffectGroup.h"
#import "GTexture.h"
#import "USKUtility.h"

//http://hooktail.sub.jp/mechanics/resistdown/
static const int NUMBER_OF_PARTICLE = 700;

typedef struct
{
    GLKVector3 initial_position;
    GLKVector3 initial_velocity;
}Vertex;

@implementation USKAddEffectRenderer
{
    GShader *_shader;
    GState *_state;
    NSMutableArray *_effectGroup;
    GTexture *_texture;
}
- (id)init
{
    if(self = [super init])
    {
        _effectGroup = [NSMutableArray array];
        
        _state = [GState new];
        _state.blend = YES;
        _state.blend_sfactor = GL_SRC_ALPHA;
        _state.blend_dfactor = GL_ONE;
        _state.depthWrite = NO;
        
        NSString *backgroundPath = [[NSBundle mainBundle] pathForResource:@"particle.png" ofType:@""];
        _texture = [[GTexture alloc] initWithContentsOfFile:backgroundPath
                                              interpolation:GL_LINEAR
                                                       wrap:GL_CLAMP_TO_EDGE];
        
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform float u_time;
                                            uniform mat4 u_transform;
                                            attribute vec3 a_initial_position;
                                            attribute vec3 a_initial_velocity;
                                            
                                            const float K = 0.1;
                                            const float M = 0.1;
                                            const float G = -0.3;
                                            
                                            void main()
                                            {
                                                vec3 C2 = vec3(a_initial_position.x + M / K * a_initial_velocity.x,
                                                               a_initial_position.y + M / K * a_initial_velocity.y,
                                                               a_initial_position.z + M / K * a_initial_velocity.z);
                                                
                                                float y = - M / K * a_initial_velocity.y * exp(- K / M * u_time) + ((M * G) / K) * u_time + C2.y;
                                                
                                                float x = - (M / K) * a_initial_velocity.x * exp(- (K / M) * u_time) + C2.x;
                                                float z = - (M / K) * a_initial_velocity.z * exp(- (K / M) * u_time) + C2.z;
                                                
                                                vec4 position = vec4(x, y, z, 1.0);
                                                vec4 transformed = u_transform * position;
                                                gl_Position = transformed;
                                                gl_PointSize = 30.0 / transformed.w;
                                            }
                                            );
        NSString *const kFS = SHADER_STRING(
                                            uniform sampler2D u_image;
                                            void main()
                                            {
                                                gl_FragColor.rgb = texture2D(u_image, gl_PointCoord).rgb;
                                                gl_FragColor.a = 1.0;
                                            }
                                            );
        _shader = [[GShader alloc] initWithVertexShader:kVS fragmentShader:kFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        
        USKAddEffectGroup *group = [USKAddEffectGroup new];
        Vertex *vertices = malloc(sizeof(Vertex) * NUMBER_OF_PARTICLE);
        for(int i = 0 ; i < NUMBER_OF_PARTICLE ; ++i)
        {
            GLKVector3 direction = [USKUtility randomSphere];
            float power = [USKUtility remapValue:rand() iMin:0 iMax:RAND_MAX oMin:0.1 oMax:1.5];
            
            vertices[i].initial_position = GLKVector3Make(0, 0.4, 0);
            vertices[i].initial_velocity = GLKVector3MultiplyScalar(direction, power);
        }
        
        group.vbo = [[GVbo alloc] initWithBytes:vertices size:sizeof(Vertex) * NUMBER_OF_PARTICLE type:GVBO_VERTEX];
        group.time = 0.0;
        
        free(vertices);
        
        [_effectGroup addObject:group];
    }
    return self;
}
- (void)update
{
    for(USKAddEffectGroup *group in _effectGroup)
    {
        group.time += (1.0 / 60.0);
    }
}
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm
{
    sm.currentState = _state;
    
    [_shader bind:^{
        [_shader setMatrix4:GLKMatrix4Multiply([camera proj], [camera view]) forUniformKey:@"u_transform"];
        
        int a_initial_position = [_shader attribLocationForKey:@"a_initial_position"];
        int a_initial_velocity = [_shader attribLocationForKey:@"a_initial_velocity"];
        glEnableVertexAttribArray(a_initial_position);
        glEnableVertexAttribArray(a_initial_velocity);
        
        for(USKAddEffectGroup *group in _effectGroup)
        {
            [group.vbo bind:^{
                glVertexAttribPointer(a_initial_position, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (char *)0 + offsetof(Vertex, initial_position));
                glVertexAttribPointer(a_initial_velocity, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (char *)0 + offsetof(Vertex, initial_velocity));
            }];
            
            [_shader setFloat:group.time forUniformKey:@"u_time"];
            
            glDrawArrays(GL_POINTS, 0, NUMBER_OF_PARTICLE);
        }
        
        glDisableVertexAttribArray(a_initial_position);
        glDisableVertexAttribArray(a_initial_velocity);
    }];
}
@end
