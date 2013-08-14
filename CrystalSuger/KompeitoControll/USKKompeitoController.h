//
//  KompeitoController.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>

#import "USKPhysicsWorld.h"
#import "USKPhysicsSphere.h"
#import "USKKompeitoEntity.h"

@interface USKKompeitoController : NSObject
- (id)initWithUSKPhysicsWorld:(USKPhysicsWorld *)USKPhysicsWorld;

- (void)add;

//not copy
- (NSArray *)allKompeito;
@end
