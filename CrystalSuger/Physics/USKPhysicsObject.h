//
//  USKPhysicsObject.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class USKPhysicsWorld;
@interface USKPhysicsObject : NSObject
{
@public
    void *_dynamicsWorld;
    void *_motionState;
    void *_body;
}

- (void)removeFromWorld;
- (void)aabbMin:(GLKVector3 *)min max:(GLKVector3 *)max;
@property (weak, nonatomic) USKPhysicsWorld *world;
@end
