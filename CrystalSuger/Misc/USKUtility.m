//
//  USKUtility.m
//  SugerTimer
//
//  Created by 吉村 篤 on 2013/03/30.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import "USKUtility.h"

@implementation USKUtility
+ (float)remapValue:(float)value iMin:(float)iMin iMax:(float)iMax oMin:(float)oMin oMax:(float)oMax
{
    return (value - iMin) * ((oMax - oMin) / (iMax - iMin)) + oMin;
}
+ (double)remapValued:(double)value iMin:(double)iMin iMax:(double)iMax oMin:(double)oMin oMax:(double)oMax
{
    return (value - iMin) * ((oMax - oMin) / (iMax - iMin)) + oMin;
}
+ (BOOL)isIphone5
{
    return (int)[[UIScreen mainScreen] bounds].size.height == 568;
}
+ (BOOL)isRetina
{
    return (int)[UIScreen mainScreen].scale == 2;
}
+ (GLKVector3)randomSphere
{
    float rx = [USKUtility remapValue:rand() iMin:0 iMax:RAND_MAX oMin:0.0f oMax:1.0f];
    float ry = [USKUtility remapValue:rand() iMin:0 iMax:RAND_MAX oMin:0.0f oMax:1.0f];
    
    float theta = 2.0f * acos(sqrt(1.0 - rx));
    float phi = M_PI * 2.0f * ry;
    float r = 1.0;
    float x = r * sinf(theta) * cosf(phi);
    float y = r * sinf(theta) * sinf(phi);
    float z = r * cosf(theta);
    GLKVector3 v = {y, z, x};
    return v;
}
@end
