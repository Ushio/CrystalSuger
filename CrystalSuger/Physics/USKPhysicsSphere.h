//
//  USKPhysicsSphere.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPhysicsObject.h"

#import <GLKit/GLKit.h>

@interface USKPhysicsSphere : USKPhysicsObject
- (id)init;
- (id)initWithPosition:(GLKVector3)position;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKQuaternion rotation;
@end
