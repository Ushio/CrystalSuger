#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define SHADER_ERROR_HANDLE(e) if(e){ NSLog(@"%@", e.description); abort(); }

/**
 */
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
