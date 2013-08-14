//
//  Kompeito.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/28.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USKPhysicsSphere.h"

enum KompeitoColor
{
    KOMPEITO_COLOR_YELLO = 0,
    KOMPEITO_COLOR_WHITE,
    KOMPEITO_COLOR_BLUE,
};

static const GLKVector4 kKompeitoColorValues[] =
{
    {1.0f, 0.83, 0.31f, 1.0f},
    {1.0f, 1.0f, 1.0f, 1.0f},
    {0.64f, 0.9f, 0.9f, 1.0f},
};

@interface USKKompeitoEntity : NSObject
@property (nonatomic, assign) int color;
@property (strong, nonatomic) USKPhysicsSphere *USKPhysicsSphere;
@end
