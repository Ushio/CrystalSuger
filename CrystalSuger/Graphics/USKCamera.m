#import "USKCamera.h"

@implementation USKCamera
- (id)init
{
    self = [super init];
    if (self) {
        self.fieldOfView = 45.0f;
        self.aspect = 1.0f;
        self.near = 0.1f;
        self.far = 100.0f;
        
        self.position = GLKVector3Make(0, 0, 0);
        self.lookAt = GLKVector3Make(0, 0, -1);
        self.up = GLKVector3Make(0, 1, 0);
    }
    return self;
}
- (GLKMatrix4) view
{
    return GLKMatrix4MakeLookAt(_position.x, _position.y, _position.z, _lookAt.x, _lookAt.y, _lookAt.z, _up.x, _up.y, _up.z);
}
- (GLKMatrix4) proj
{
    return GLKMatrix4MakePerspective(GLKMathDegreesToRadians(self.fieldOfView), self.aspect, self.near, self.far);
}

- (GLKVector3)right
{
    return GLKVector3Normalize(GLKVector3CrossProduct(self.up, self.back));
}
- (GLKVector3)back
{
    return GLKVector3Normalize(GLKVector3Negate(GLKVector3Subtract(self.lookAt, self.position)));
}
@end
