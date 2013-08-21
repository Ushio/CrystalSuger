/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


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
