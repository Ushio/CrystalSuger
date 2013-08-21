/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define SHADER_ERROR_HANDLE(e) if(e){ NSLog(@"%@", e.description); abort(); }

@interface GShader : NSObject
- (id)initWithVertexShader:(NSString *)vs fragmentShader:(NSString *)fs error:(out NSError **)error;

- (void)setTextureUnit:(int)unit       forUniformKey:(NSString *)key;
- (void)setFloat:(float)floatValue     forUniformKey:(NSString *)key;
- (void)setVector2:(GLKVector2)vector2 forUniformKey:(NSString *)key;
- (void)setVector3:(GLKVector3)vector3 forUniformKey:(NSString *)key;
- (void)setVector4:(GLKVector4)vector4 forUniformKey:(NSString *)key;
- (void)setMatrix2:(GLKMatrix2)matrix2 forUniformKey:(NSString *)key;
- (void)setMatrix3:(GLKMatrix3)matrix3 forUniformKey:(NSString *)key;
- (void)setMatrix4:(GLKMatrix4)matrix4 forUniformKey:(NSString *)key;

- (int)attribLocationForKey:(NSString *)key;

- (void)bind:(void(^)(void))blocks;
@end
