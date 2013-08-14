//
//  USKPhysicsStaticMesh.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKPhysicsObject.h"

#import <GLKit/GLKit.h>

@interface USKPhysicsStaticMesh : USKPhysicsObject
- (id)initWithTriMesh:(const GLKVector3 *)mesh numberOfVertices:(int)numberOfVertices;
@end
