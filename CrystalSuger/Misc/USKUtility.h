//
//  USKUtility.h
//  SugerTimer
//
//  Created by 吉村 篤 on 2013/03/30.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface USKUtility : NSObject
+ (float)remapValue:(float)value iMin:(float)iMin iMax:(float)iMax oMin:(float)oMin oMax:(float)oMax;
+ (double)remapValued:(double)value iMin:(double)iMin iMax:(double)iMax oMin:(double)oMin oMax:(double)oMax;

+ (BOOL)isIphone5;
+ (BOOL)isRetina;

+ (GLKVector3)randomSphere;

@end

#define ARRAY_SIZE(array) (sizeof(array) / sizeof(array[0]))

static float clamp(float value, float min, float max)
{
    return MIN(MAX(value, min), max);
}
