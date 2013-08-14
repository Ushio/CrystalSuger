//
//  Camera.h
//  phial_render
//
//  Created by 吉村 篤 on 12/05/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

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
