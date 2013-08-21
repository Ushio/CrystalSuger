/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

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
