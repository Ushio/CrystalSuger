//
//  KompeitoController.m
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKKompeitoController.h"

@implementation USKKompeitoController
{
    USKPhysicsWorld *_USKPhysicsWorld;
    NSMutableArray *_kompeitos;
}
- (id)initWithUSKPhysicsWorld:(USKPhysicsWorld *)USKPhysicsWorld
{
    if(self = [super init])
    {
        _USKPhysicsWorld = USKPhysicsWorld;
        _kompeitos = [NSMutableSet set];
    }
    return self;
}
- (void)add
{
    USKKompeitoEntity *newKompeito = [USKKompeitoEntity new];
    newKompeito.color = rand() % 3;
    newKompeito.USKPhysicsSphere = [USKPhysicsSphere new];
    newKompeito.USKPhysicsSphere.position = GLKVector3Make(0.0f, 0.3f, 0.0f);
    [_USKPhysicsWorld addPhysicsObject:newKompeito.USKPhysicsSphere];
    [_kompeitos addObject:newKompeito];
}
- (NSArray *)allKompeito
{
    return _kompeitos;
}
@end
