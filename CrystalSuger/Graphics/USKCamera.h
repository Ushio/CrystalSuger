/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import <GLKit/GLKit.h>
#import "USKCameraProtocol.h"
@interface USKCamera : NSObject<USKCameraProtocol>
@property (nonatomic) float fieldOfView;
@property (nonatomic) float aspect;
@property (nonatomic) float near;
@property (nonatomic) float far;

@property (nonatomic) GLKVector3 position;
@property (nonatomic) GLKVector3 lookAt;
@property (nonatomic) GLKVector3 up;

@property (nonatomic, readonly) GLKMatrix4 view;
@property (nonatomic, readonly) GLKMatrix4 proj;

@property (nonatomic, readonly) GLKVector3 right;
@property (nonatomic, readonly) GLKVector3 back;
@end
