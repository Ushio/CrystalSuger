/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

#import "GShader.h"
#import "GMacros.h"

#import <GLKit/GLKit.h>


@implementation GShader
{
    unsigned _program;
    BOOL _isBinding;
    
    NSMutableDictionary *_uniformLocationCache;
    NSMutableDictionary *_attributeLocationCache;
}
- (id)initWithVertexShader:(NSString *)vs fragmentShader:(NSString *)fs error:(out NSError **)error
{
    if(self = [super init])
    {
        const char *vsSource = vs.UTF8String;
        const char *fsSource = fs.UTF8String;
        unsigned vsShader = glCreateShader(GL_VERTEX_SHADER);
        unsigned fsShader = glCreateShader(GL_FRAGMENT_SHADER);
        
        _program = glCreateProgram();
        
        glShaderSource(vsShader, 1, &vsSource, 0);
        glCompileShader(vsShader);
        
        int vsStatus;
        glGetShaderiv(vsShader, GL_COMPILE_STATUS, &vsStatus);
        if(vsStatus == GL_FALSE)
        {
            char *message;
            GLint logLength;
            
            glGetShaderiv(vsShader, GL_INFO_LOG_LENGTH, &logLength);
            message = malloc(logLength);
            glGetShaderInfoLog(vsShader, logLength, &logLength, message);
            if(error)
            {
                *error = [NSError errorWithDomain:[NSString stringWithUTF8String:message]
                                             code:0
                                         userInfo:nil];
            }

            free(message);
        }
        
        glShaderSource(fsShader, 1, &fsSource, 0);
        glCompileShader(fsShader);
        
        int fsStatus;
        glGetShaderiv(fsShader, GL_COMPILE_STATUS, &fsStatus);
        if(fsStatus == GL_FALSE)
        {
            char *message;
            GLint logLength;
            
            glGetShaderiv(fsShader, GL_INFO_LOG_LENGTH, &logLength);
            message = malloc(logLength);
            glGetShaderInfoLog(fsShader, logLength, &logLength, message);
            
            if(error)
            {
                *error = [NSError errorWithDomain:[NSString stringWithUTF8String:message]
                                             code:0
                                         userInfo:nil];
            }
            
            free(message);
        }
        
        glAttachShader(_program, vsShader);
        glAttachShader(_program, fsShader);
        glLinkProgram(_program);
        
        glDetachShader(_program, vsShader);
        glDetachShader(_program, fsShader);
        glDeleteShader(vsShader);
        glDeleteShader(fsShader);
        
        _uniformLocationCache = [NSMutableDictionary dictionary];
        _attributeLocationCache = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)dealloc
{
    glDeleteProgram(_program);
}
- (int)locationForUniformKey:(NSString *)key
{
    NSNumber *uniformLocation = _uniformLocationCache[key];
    if(uniformLocation)
    {
        //NOP
    }
    else
    {
        int location = glGetUniformLocation(_program, key.UTF8String);
        if(location == -1)
        {
            NSLog(@"invalid key : %@", key);
        }
        else
        {
            uniformLocation = @(location);
            _uniformLocationCache[key] = uniformLocation;
        }
    }
    return uniformLocation.intValue;
}
- (void)setTextureUnit:(int)unit forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniform1i([self locationForUniformKey:key], unit);
}
- (void)setFloat:(float)floatValue forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniform1f([self locationForUniformKey:key], floatValue);
}
- (void)setVector2:(GLKVector2)vector2 forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniform2f([self locationForUniformKey:key], vector2.x, vector2.y);
}
- (void)setVector3:(GLKVector3)vector3 forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniform3f([self locationForUniformKey:key], vector3.x, vector3.y, vector3.z);
}
- (void)setVector4:(GLKVector4)vector4 forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniform4f([self locationForUniformKey:key], vector4.x, vector4.y, vector4.z, vector4.w);
}
- (void)setMatrix2:(GLKMatrix2)matrix2 forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniformMatrix2fv([self locationForUniformKey:key], 1, GL_FALSE, matrix2.m);
}
- (void)setMatrix3:(GLKMatrix3)matrix3 forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniformMatrix3fv([self locationForUniformKey:key], 1, GL_FALSE, matrix3.m);
}
- (void)setMatrix4:(GLKMatrix4)matrix4 forUniformKey:(NSString *)key
{
    NSAssert(_isBinding, @"no binding");
    glUniformMatrix4fv([self locationForUniformKey:key], 1, GL_FALSE, matrix4.m);
}

- (void)bind:(void(^)(void))blocks
{
    glUseProgram(_program);
 
    _isBinding = YES;
    if(blocks)
        blocks();
    _isBinding = NO;
    
    glUseProgram(0);
}
- (int)attribLocationForKey:(NSString *)key
{
    NSNumber *attributeLocation = _attributeLocationCache[key];
    if(attributeLocation)
    {
        //NOP
    }
    else
    {
        int location = glGetAttribLocation(_program, key.UTF8String);
        if(location == -1)
        {
            NSLog(@"invalid key : %@", key);
        }
        else
        {
            attributeLocation = @(location);
            _attributeLocationCache[key] = attributeLocation;
        }
    }
    return attributeLocation.intValue;
}
@end
