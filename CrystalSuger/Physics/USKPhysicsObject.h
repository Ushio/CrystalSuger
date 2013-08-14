//
//  USKPhysicsObject.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class USKPhysicsWorld;
@interface USKPhysicsObject : NSObject
{
@public
    void *_dynamicsWorld;
    void *_motionState;
    void *_body;
}

- (void)removeFromWorld;
@property (weak, nonatomic) USKPhysicsWorld *world;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@end
