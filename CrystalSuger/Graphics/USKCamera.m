/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


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
