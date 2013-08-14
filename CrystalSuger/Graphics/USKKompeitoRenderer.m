//
//  KompeitoRenderer.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKKompeitoRenderer.h"

#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "GMutableVbo.h"
#import "GVao.h"
#import "USKUtility.h"

#import "USKKompeitoVertices.h"
#import "USKKompeitoSphere.h"
#import "USKKompeitoConstants.h"

@implementation USKKompeitoRenderer
{
    GShader *_shader;

    GState *_state;
    GVbo *_kompeitoVertices;
    GVbo *_kompeitoIndices;
    GVao *_vao;
}
- (id)init
{
    if(self = [super init])
    {
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform mat4 u_view_world;
                                            uniform mat4 u_proj;
                                            uniform mat3 u_normal;
                                            uniform vec4 u_color;
                                            uniform float u_scaling;
                                            
                                            attribute vec4 a_position;
                                            attribute vec3 a_normal;
                                            
                                            varying vec4 v_color;
                                            void main()
                                            {
                                                gl_Position = u_proj * u_view_world * a_position;
                                                
                                                float pz = u_view_world[0][2] * a_position.x + u_view_world[1][2] * a_position.y + u_view_world[2][2] * a_position.z;
                                                float factor = pz / (length(a_position) * u_scaling);
                                                float darkness = mix(1.0, 0.8, factor * 2.0);
                                                
                                                vec3 n = normalize(u_normal * a_normal);
                                                vec3 r = vec3(0.57735026918963, 0.57735026918963, -0.57735026918963);
                                                vec3 v = vec3(0.0, 0.0, 1.0) - 2.0 * n.z * n; /*reflect(vec3(0.0, 0.0, 1.0), normal);*/
                                                float specular = pow(abs(clamp(dot(v, r), -1.0, 0.0)), 9.0);
                                                
                                                v_color = u_color * darkness + vec4(specular, specular, specular, 0.0);
                                            }
                                            );
        NSString *const kFS = SHADER_STRING(
                                            precision highp float;
                                            varying vec4 v_color;
                                            void main()
                                            {
                                                gl_FragColor = v_color;
                                            }
                                            );
        
        _shader = [[GShader alloc] initWithVertexShader:kVS fragmentShader:kFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        _kompeitoVertices = [[GVbo alloc] initWithBytes:kKompeitoVertices size:sizeof(kKompeitoVertices) type:GVBO_VERTEX];
        _kompeitoIndices = [[GVbo alloc] initWithBytes:kKompeitoIndices size:sizeof(kKompeitoIndices) type:GVBO_ELEMENT];
        
        _vao = [GVao new];
        [_vao bind:^{
            [_kompeitoVertices bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                int a_normal = [_shader attribLocationForKey:@"a_normal"];
                glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(KompeitoVertex), (char *)0 + offsetof(KompeitoVertex, position));
                glVertexAttribPointer(a_normal, 3, GL_FLOAT, GL_FALSE, sizeof(KompeitoVertex), (char *)0 + offsetof(KompeitoVertex, normal));
                glEnableVertexAttribArray(a_position);
                glEnableVertexAttribArray(a_normal);
            }];
        }];
        
        _state = [GState new];
        _state.depthTest = YES;
        _state.cullFace = YES;
    }
    return self;
}
- (void)renderWithKompeitos:(NSArray *)kompeitos camera:(id<USKCameraProtocol>)camera time:(float)time sm:(GStateManager *)sm
{
    sm.currentState = _state;
    
    const float size = 0.15;
        
    [_shader bind:^{
        [_shader setMatrix4:[camera proj] forUniformKey:@"u_proj"];
        [_shader setFloat:size forUniformKey:@"u_scaling"];
        
        [_vao bind:^{
            [_kompeitoIndices bind:^{
                for(int i = 0 ; i < 3 ; ++i)
                {
                    [_shader setVector4:kKompeitoColorValues[i] forUniformKey:@"u_color"];
                    
                    for(USKKompeitoSphere *kompeito in kompeitos)
                    {
                        if(kompeito.color == i)
                        {
                            GLKVector3 position = kompeito.position;
                            GLKQuaternion rotation = kompeito.rotation;
                            
                            GLKMatrix4 world = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
                            world = GLKMatrix4Multiply(world, GLKMatrix4MakeWithQuaternion(rotation));
                            world = GLKMatrix4Scale(world, size, size, size);
                            
                            GLKMatrix4 view_world = GLKMatrix4Multiply([camera view], world);
                            [_shader setMatrix4:view_world forUniformKey:@"u_view_world"];
                            [_shader setMatrix3:GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(view_world), NULL) forUniformKey:@"u_normal"];
                            
                            glDrawElements(GL_TRIANGLES, ARRAY_SIZE(kKompeitoIndices), GL_UNSIGNED_SHORT, (void *)0);
                        }
                    }
                }
            }];
        }];
    }];
}
@end
