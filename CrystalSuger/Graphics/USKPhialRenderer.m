//
//  USKPhialBodyRenderer.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/15.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKPhialRenderer.h"


#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "GVbo.h"
#import "GVao.h"
#import "USKUtility.h"

#import "USKPhialBodyVertices.h"
#import "USKPhialWingVertices.h"

#import "USKPigeonRenderer.h"

@implementation USKPhialRenderer
{
    GShader *_shader;
    GState *_backState;
    GState *_frontState;
    
    GVao *_bodyVao;
    GVbo *_bodyVertices;
    GVbo *_bodyIndices;
    
    GVao *_wingVao;
    GVbo *_wingVertices;
    GVbo *_wingIndices;
    
    USKPigeonRenderer *_pigeonRenderer;
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
        
        
        //view space lighting
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform mat4 u_proj_view_world;
                                            uniform mat3 u_normal;
                                            
                                            uniform float u_power_rim;
                                            
                                            attribute vec4 a_position;
                                            attribute vec3 a_normal;
                                            
                                            varying vec4 v_color;
                                            void main()
                                            {
                                                gl_Position = u_proj_view_world * a_position;
                                                
                                                vec3 n = normalize(u_normal * a_normal);
                                                vec3 r = vec3(0.391353, 0.391353, 0.832878);
                                                vec3 v = vec3(0.0, 0.0, 1.0) - 2.0 * n.z * n; /*reflect(vec3(0.0, 0.0, 1.0), normal);*/
                                                float specular = pow(abs(clamp(dot(v, r), -1.0, 0.0)), 9.0) * 1.2;
                                                float rim = clamp(pow(1.0 - abs(n.z) + 0.1, u_power_rim), 0.0, 1.0);
                                                float intencity = specular + rim;
                                                
                                                v_color = vec4(intencity, intencity, intencity, intencity);
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
        
        //Body
        _bodyVertices = [[GVbo alloc] initWithBytes:kPhialBodyVertices size:sizeof(kPhialBodyVertices) type:GVBO_VERTEX];
        _bodyIndices = [[GVbo alloc] initWithBytes:kPhialBodyIndices size:sizeof(kPhialBodyIndices) type:GVBO_ELEMENT];
        
        _bodyVao = [[GVao alloc] init];
        [_bodyVao bind:^{
            [_bodyVertices bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                int a_normal = [_shader attribLocationForKey:@"a_normal"];
                glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(PhialBodyVertex), (char *)0 + offsetof(PhialBodyVertex, position));
                glVertexAttribPointer(a_normal, 3, GL_FLOAT, GL_FALSE, sizeof(PhialBodyVertex), (char *)0 + offsetof(PhialBodyVertex, normal));
                glEnableVertexAttribArray(a_position);
                glEnableVertexAttribArray(a_normal);
            }];
        }];
        
        //Wing
        _wingVertices = [[GVbo alloc] initWithBytes:kPhialWingVertices size:sizeof(kPhialWingVertices) type:GVBO_VERTEX];
        _wingIndices = [[GVbo alloc] initWithBytes:kPhialWingIndices size:sizeof(kPhialWingIndices) type:GVBO_ELEMENT];
        
        _wingVao = [[GVao alloc] init];
        [_wingVao bind:^{
            [_wingVertices bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                int a_normal = [_shader attribLocationForKey:@"a_normal"];
                glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(PhialWingVertex), (char *)0 + offsetof(PhialWingVertex, position));
                glVertexAttribPointer(a_normal, 3, GL_FLOAT, GL_FALSE, sizeof(PhialWingVertex), (char *)0 + offsetof(PhialWingVertex, normal));
                glEnableVertexAttribArray(a_position);
                glEnableVertexAttribArray(a_normal);
            }];
        }];
        
        
        _pigeonRenderer = [[USKPigeonRenderer alloc] init];
    }
    return self;
}
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm
{
    const float SCALE = 0.3;
    const float HEIGHT = 0.48f;
    const GLKVector3 L_WING_POSITION = {-1.7, 1.65, 0.0};
    const GLKVector3 R_WING_POSITION = {1.7, 1.65, 0.0};
    const float SCALE_WING = 0.8f;
    
    GLKMatrix4 rootWorld = GLKMatrix4Identity;
    rootWorld = GLKMatrix4Scale(rootWorld, SCALE, SCALE, SCALE);
    rootWorld = GLKMatrix4Translate(rootWorld, 0, HEIGHT, 0);
    
    GLKMatrix4 lWingWorld = rootWorld;
    lWingWorld = GLKMatrix4Translate(lWingWorld, L_WING_POSITION.x, L_WING_POSITION.y, L_WING_POSITION.z);
    lWingWorld = GLKMatrix4RotateY(lWingWorld, M_PI);
    lWingWorld = GLKMatrix4Scale(lWingWorld, SCALE_WING, SCALE_WING, SCALE_WING);
    
    GLKMatrix4 rWingWorld = rootWorld;
    rWingWorld = GLKMatrix4Translate(rWingWorld, R_WING_POSITION.x, R_WING_POSITION.y, R_WING_POSITION.z);
    rWingWorld = GLKMatrix4Scale(rWingWorld, SCALE_WING, SCALE_WING, SCALE_WING);
    
    void (^render)(GVao *, GVbo *, int, GLKMatrix4, float) = ^(GVao *vao, GVbo *indices, int count, GLKMatrix4 world, float powerRim)
    {
        GLKMatrix4 view_world = GLKMatrix4Multiply([camera view], world);
        GLKMatrix4 proj_view_world = GLKMatrix4Multiply([camera proj], view_world);
        
        [_shader setMatrix4:proj_view_world forUniformKey:@"u_proj_view_world"];
        [_shader setMatrix3:GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(view_world), NULL) forUniformKey:@"u_normal"];
        [_shader setFloat:powerRim forUniformKey:@"u_power_rim"];
        
        [vao bind:^{
            [indices bind:^{
                sm.currentState = _backState;
                glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_SHORT, (void *)0);
                sm.currentState = _frontState;
                glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_SHORT, (void *)0);
            }];
        }];
    };
    
    //pigeon
    [_pigeonRenderer renderWithCamera:camera parent:rootWorld sm:sm];
    
    [_shader bind:^{
        //simplest z sort
        float ldistance = GLKVector3Distance([camera position] , L_WING_POSITION);
        float rdistance = GLKVector3Distance([camera position] , R_WING_POSITION);
        if(ldistance > rdistance)
        {
            render(_wingVao, _wingIndices, ARRAY_SIZE(kPhialWingIndices), lWingWorld, 1.0f);
            render(_bodyVao, _bodyIndices, ARRAY_SIZE(kPhialBodyIndices), rootWorld, 2.0f);
            render(_wingVao, _wingIndices, ARRAY_SIZE(kPhialWingIndices), rWingWorld, 1.0f);
        }
        else
        {
            render(_wingVao, _wingIndices, ARRAY_SIZE(kPhialWingIndices), rWingWorld, 1.0f);
            render(_bodyVao, _bodyIndices, ARRAY_SIZE(kPhialBodyIndices), rootWorld, 2.0f);
            render(_wingVao, _wingIndices, ARRAY_SIZE(kPhialWingIndices), lWingWorld, 1.0f);
        }
    }];
}

@end
