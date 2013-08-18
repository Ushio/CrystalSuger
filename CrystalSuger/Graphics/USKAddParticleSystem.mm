//
//  USKAddParticleSystem.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/18.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKAddParticleSystem.h"

#include <vector>

#import "GMacros.h"
#import "GShader.h"
#import "GTexture.h"
#import "GMutableVbo.h"
#import "USKUtility.h"
#import "UIImage+PDF.h"

typedef struct
{
    GLKVector3 position;
    GLKVector3 velocity;
    GLKVector3 color;
    double beginTime;
}Particle_t;

typedef struct
{
    GLKVector3 position;
    GLKVector4 color;
}ParticleVertex_t;

static const float G = 2.0f;
static const float K = 2.0f;
static const float LIFE = 3.0f;

//-1~1
static float random_z()
{
    float v01 = (float)rand() / (float)RAND_MAX;
    return v01 * 2.0f - 1.0f;
}
//0~2PI
static float random_phi()
{
    float v01 = (float)rand() / (float)RAND_MAX;
    return v01 * 2.0f * M_PI;
}
static GLKVector3 sphere_random()
{
    float z = random_z();
    float phi = random_phi();
    float opt = sqrtf(1.0f - z * z);
    return GLKVector3Make(opt * cosf(phi),
                          opt * sinf(phi),
                          z);
}
static float exponential_ease_out(float time, float begin, float change, float duration)
{
    return change * (-powf(2.0f, -10.0f * time / duration) + 1.0f) + begin;
}

@implementation USKAddParticleSystem
{
    double _integralTime;
    
    std::vector<Particle_t> _particles;
    std::vector<ParticleVertex_t> _particleVertices;
    
    GShader *_shader;
    GMutableVbo *_vbo;
    GState *_state;
    
    GTexture *_image;
}
- (id)init
{
    if(self = [super init])
    {
        NSError *error;
        NSString *const kVS = SHADER_STRING(
                                            uniform mat4 u_proj_view_world;
                                            
                                            attribute vec4 a_position;
                                            attribute vec4 a_color;

                                            varying vec4 v_color;

                                            void main()
                                            {
                                                gl_Position = u_proj_view_world * a_position;
                                                v_color = a_color;
                                                gl_PointSize = 50.0 / gl_Position.w;
                                            }
                                            );
        NSString *const kFS = SHADER_STRING(
                                            precision lowp float;
                                            
                                            uniform sampler2D u_image;
                                            
                                            varying vec4 v_color;
                                            
                                            void main()
                                            {
                                                float t = texture2D(u_image, gl_PointCoord).r;
                                                gl_FragColor = vec4(v_color.r * t, v_color.g * t, v_color.b * t, v_color.a);
                                            }
                                            );
        
        _shader = [[GShader alloc] initWithVertexShader:kVS fragmentShader:kFS error:&error];
        SHADER_ERROR_HANDLE(error);
        
        _state = [[GState alloc] init];
        _state.blend = YES;
        _state.blend_sfactor = GL_SRC_ALPHA;
        _state.blend_dfactor = GL_ONE;
        _state.depthTest = NO;
        _state.depthWrite = NO;
        
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Particle.pdf" ofType:@""];
        UIImage *image = [UIImage imageWithContentsOfPDF:imagePath height:32];
        
        _image = [[GTexture alloc] initWithCGImage:image.CGImage
                                     interpolation:GL_LINEAR
                                              wrap:GL_CLAMP_TO_EDGE];
    }
    return self;
}

- (void)addWithPosition:(GLKVector3)position color:(GLKVector3)color
{
    for(int i = 0 ; i < 50 ; ++i)
    {
        float w = ((float)rand() / (float)RAND_MAX) * 2.0f - 1.0f;
        float r = 1.5f + w * 0.5f;
        Particle_t newParticle = {
            position,
            GLKVector3MultiplyScalar(sphere_random(), r),
            color,
            _integralTime,
        };
        _particles.push_back(newParticle);
    }
}
- (void)stepWithDelta:(double)delta
{
    _integralTime += delta;
    
    _particleVertices.clear();
    
    double time = _integralTime;
    _particles.erase(std::remove_if(_particles.begin(), _particles.end(), [time](const Particle_t& particle){
        return time - particle.beginTime > LIFE;
    }), _particles.end());
    
    for(Particle_t& particle : _particles)
    {
        //更新
        particle.position = GLKVector3Add(particle.position, GLKVector3MultiplyScalar(particle.velocity, delta));
        particle.velocity = GLKVector3Add(particle.velocity, GLKVector3MultiplyScalar(GLKVector3MultiplyScalar(particle.velocity, -K), delta));
        particle.velocity.y += -G * delta;
                                          
        //頂点バッファへ
        float elapsed = time - particle.beginTime;
        float alpha = exponential_ease_out(elapsed, 1.0f, -1.0f, LIFE);
        ParticleVertex_t v = {
            particle.position,
            GLKVector4MakeWithVector3(particle.color, alpha),
//            GLKVector4Make(1.0f, 1.0f, 1.0f, alpha),
        };
        _particleVertices.push_back(v);
    }
    
    //転送
    if(_vbo.size < _particleVertices.size() * sizeof(ParticleVertex_t))
    {
        _vbo = [[GMutableVbo alloc] initWithBytes:&_particleVertices[0] size:_particleVertices.size() * sizeof(ParticleVertex_t) type:GVBO_VERTEX];
    }
    else
    {
        [_vbo map:^(void *pLocked) {
            memcpy(pLocked, &_particleVertices[0], _particleVertices.size() * sizeof(ParticleVertex_t));
        }];
    }
}
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm
{
    if(_particles.size() == 0)
        return;
    
    [sm setCurrentState:_state];
    
    sm.activeTexture = GL_TEXTURE0;
    glBindTexture(GL_TEXTURE_2D, _image.name);

    [_shader bind:^{
        GLKMatrix4 proj_view_world = GLKMatrix4Multiply([camera proj], [camera view]);
        [_shader setMatrix4:proj_view_world forUniformKey:@"u_proj_view_world"];
        [_shader setTextureUnit:0 forUniformKey:@"u_image"];
        
        [_vbo bind:^{
            int a_position = [_shader attribLocationForKey:@"a_position"];
            int a_color = [_shader attribLocationForKey:@"a_color"];
            glVertexAttribPointer(a_position, 3, GL_FLOAT, GL_FALSE, sizeof(ParticleVertex_t), (char *)0 + offsetof(ParticleVertex_t, position));
            glVertexAttribPointer(a_color, 4, GL_FLOAT, GL_FALSE, sizeof(ParticleVertex_t), (char *)0 + offsetof(ParticleVertex_t, color));
            glEnableVertexAttribArray(a_position);
            glEnableVertexAttribArray(a_color);
            
            glDrawArrays(GL_POINTS, 0, _particles.size());
            
            glDisableVertexAttribArray(a_position);
            glDisableVertexAttribArray(a_color);
        }];
    }];
}
@end
