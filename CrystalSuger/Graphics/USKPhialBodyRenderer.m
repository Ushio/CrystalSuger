//
//  USKPhialBodyRenderer.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/15.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKPhialBodyRenderer.h"


#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "GMutableVbo.h"
#import "GVao.h"
#import "USKUtility.h"

#import "USKPhialBodyVertices.h"

@implementation USKPhialBodyRenderer
{
    GShader *_shader;
    GState *_backState;
    GState *_frontState;
    
    GVao *_vao;
    GVbo *_bodyVertices;
    GVbo *_bodyIndices;
}
- (id)init
{
    if(self = [super init])
    {
        _backState = [GState new];
        _backState.blend = YES;
        _backState.blend_sfactor = GL_SRC_ALPHA;
        _backState.blend_dfactor = GL_ONE_MINUS_SRC_ALPHA;
        _backState.depthWrite = YES;
        _backState.depthTest = YES;
        _backState.cullFace = YES;
        _backState.cullFaceMode = GL_FRONT;
        
        _frontState = [GState new];
        _frontState.blend = YES;
        _frontState.blend_sfactor = GL_SRC_ALPHA;
        _frontState.blend_dfactor = GL_ONE_MINUS_SRC_ALPHA;
        _frontState.depthWrite = YES;
        _frontState.depthTest = YES;
        _frontState.cullFace = YES;
        _frontState.cullFaceMode = GL_BACK;
        
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform mat4 u_view_world;
                                            uniform mat4 u_proj;
                                            uniform mat3 u_normal;
                                            
                                            attribute vec4 a_position;
                                            attribute vec3 a_normal;
                                            
                                            varying vec4 v_color;
                                            void main()
                                            {
                                                gl_Position = u_proj * u_view_world * a_position;
                                                
                                                vec3 n = normalize(u_normal * a_normal);
                                                vec3 r = vec3(0.39, 0.39, 0.83);
                                                vec3 v = vec3(0.0, 0.0, 1.0) - 2.0 * n.z * n; /*reflect(vec3(0.0, 0.0, 1.0), normal);*/
                                                float specular = pow(abs(clamp(dot(v, r), -1.0, 0.0)), 9.0);
                                                float rim = clamp(pow(1.0 - abs(dot(n, v)) + 0.3, 3.0), 0.0, 1.0);
                                                float intencity = specular + rim;
                                                
                                                v_color = vec4(intencity, intencity, intencity, intencity + 0.05);
                                            }
                                            );
        NSString *const kFS = SHADER_STRING(
                                            precision lowp float;
                                            varying vec4 v_color;
                                            void main()
                                            {
                                                gl_FragColor = v_color;
                                            }
                                            );
        _shader = [[GShader alloc] initWithVertexShader:kVS fragmentShader:kFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        _bodyVertices = [[GVbo alloc] initWithBytes:kPhialBodyVertices size:sizeof(kPhialBodyVertices) type:GVBO_VERTEX];
        _bodyIndices = [[GVbo alloc] initWithBytes:kPhialBodyIndices size:sizeof(kPhialBodyIndices) type:GVBO_ELEMENT];
        
        _vao = [GVao new];
        [_vao bind:^{
            [_bodyVertices bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                int a_normal = [_shader attribLocationForKey:@"a_normal"];
                glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(PhialBodyVertex), (char *)0 + offsetof(PhialBodyVertex, position));
                glVertexAttribPointer(a_normal, 3, GL_FLOAT, GL_FALSE, sizeof(PhialBodyVertex), (char *)0 + offsetof(PhialBodyVertex, normal));
                glEnableVertexAttribArray(a_position);
                glEnableVertexAttribArray(a_normal);
            }];
        }];
    }
    return self;
}
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm
{
    [_shader bind:^{
        float scale = 1.5f;
        GLKMatrix4 world = GLKMatrix4Identity;
        world = GLKMatrix4Scale(world, scale, scale, scale);
        world = GLKMatrix4Translate(world, 0, 0.11f, 0);
        
        GLKMatrix4 view_world = GLKMatrix4Multiply([camera view], world);
        view_world = GLKMatrix4Scale(view_world, 0.2, 0.2, 0.2);
        [_shader setMatrix4:view_world forUniformKey:@"u_view_world"];
        [_shader setMatrix4:[camera proj] forUniformKey:@"u_proj"];
        [_shader setMatrix3:GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(view_world), NULL) forUniformKey:@"u_normal"];
        
        [_vao bind:^{
            [_bodyIndices bind:^{
                sm.currentState = _backState;
                glDrawElements(GL_TRIANGLES, ARRAY_SIZE(kPhialBodyIndices), GL_UNSIGNED_SHORT, (void *)0);
                
                
                sm.currentState = _frontState;
                glDrawElements(GL_TRIANGLES, ARRAY_SIZE(kPhialBodyIndices), GL_UNSIGNED_SHORT, (void *)0);
            }];
        }];
    }];

}

@end
