/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "USKPigeonRenderer.h"

#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "GVbo.h"
#import "GVao.h"
#import "USKUtility.h"

#import "USKPigeonVertices.h"

@implementation USKPigeonRenderer
{
    GShader *_shader;
    
    GState *_state;
    GVbo *_pigeonVertices;
    GVbo *_pigeonIndices;
    GVao *_vao;
    
    GTexture *_image;
}
- (id)init
{
    if(self = [super init])
    {
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform mat4 u_proj_view_world;
                                            uniform mat3 u_normal;
                                            
                                            attribute vec4 a_position;
                                            attribute vec3 a_normal;
                                            attribute vec2 a_texcoord;
                                            
                                            varying float v_rim;
                                            varying vec2 v_texcoord;
                                            void main()
                                            {
                                                gl_Position = u_proj_view_world * a_position;
                                                v_texcoord = a_texcoord;
                                                
                                                vec3 n = normalize(u_normal * a_normal);
                                                v_rim = clamp(pow(1.0 - abs(n.z) + 0.1, 2.8), 0.0, 1.0);
                                            }
                                            );
        NSString *const kFS = SHADER_STRING(
                                            precision lowp float;
                                            
                                            uniform sampler2D u_image;
                                            
                                            varying float v_rim;
                                            varying vec2 v_texcoord;
                                            void main()
                                            {
                                                gl_FragColor = texture2D(u_image, v_texcoord) + vec4(v_rim, v_rim, v_rim, 0.0);
                                            }
                                            );
        
        _shader = [[GShader alloc] initWithVertexShader:kVS fragmentShader:kFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        //Body
        _pigeonVertices = [[GVbo alloc] initWithBytes:kPigeonVertices size:sizeof(kPigeonVertices) type:GVBO_VERTEX];
        _pigeonIndices = [[GVbo alloc] initWithBytes:kPigeonIndices size:sizeof(kPigeonIndices) type:GVBO_ELEMENT];
        
        _vao = [[GVao alloc] init];
        [_vao bind:^{
            [_pigeonVertices bind:^{
                int a_position = [_shader attribLocationForKey:@"a_position"];
                int a_normal = [_shader attribLocationForKey:@"a_normal"];
                int a_texcoord = [_shader attribLocationForKey:@"a_texcoord"];
                glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(PigeonVertex), (char *)0 + offsetof(PigeonVertex, position));
                glVertexAttribPointer(a_normal, 3, GL_FLOAT, GL_FALSE, sizeof(PigeonVertex), (char *)0 + offsetof(PigeonVertex, normal));
                glVertexAttribPointer(a_texcoord, 2, GL_FLOAT, GL_FALSE, sizeof(PigeonVertex), (char *)0 + offsetof(PigeonVertex, texcoord));
                glEnableVertexAttribArray(a_position);
                glEnableVertexAttribArray(a_normal);
                glEnableVertexAttribArray(a_texcoord);
            }];
        }];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pigeon.pvrtc" ofType:@""];
        _image = [[GTexture alloc] initWithContentsOfFile:imagePath
                                                 interpolation:GL_LINEAR
                                                          wrap:GL_CLAMP_TO_EDGE];
        
        _state = [GState new];
        _state.depthTest = YES;
        _state.cullFace = YES;
    }
    return self;
}
- (void)renderWithCamera:(id<USKCameraProtocol>)camera parent:(GLKMatrix4)parent sm:(GStateManager *)sm
{
    [sm setCurrentState:_state];
    
    const float SCALE = 0.23f;
    const float HEIGHT = 2.2f;
    
    GLKMatrix4 world = parent;
    world = GLKMatrix4Translate(world, 0, HEIGHT, 0);
    world = GLKMatrix4Scale(world, SCALE, SCALE, SCALE);
//    world = GLKMatrix4RotateY(world, GLKMathDegreesToRadians(90.0f));
    
    sm.activeTexture = GL_TEXTURE0;
    glBindTexture(GL_TEXTURE_2D, [_image name]);
    
    [_shader bind:^{
        GLKMatrix4 view_world = GLKMatrix4Multiply([camera view], world);
        GLKMatrix4 proj_view_world = GLKMatrix4Multiply([camera proj], view_world);
        
        [_shader setMatrix4:proj_view_world forUniformKey:@"u_proj_view_world"];
        [_shader setMatrix3:GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(view_world), NULL) forUniformKey:@"u_normal"];
        [_shader setTextureUnit:0 forUniformKey:@"u_image"];
        
        [_vao bind:^{
            [_pigeonIndices bind:^{
                glDrawElements(GL_TRIANGLES, ARRAY_SIZE(kPigeonIndices), GL_UNSIGNED_SHORT, (void *)0);
            }];
        }];
    }];
}
@end
