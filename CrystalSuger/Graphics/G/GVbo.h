//
//  GFbo.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/20.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GVBO_VERTEX,
    GVBO_ELEMENT,
}GVboType;

@interface GVbo : NSObject
{
    @protected
    GLuint _buffer;
    int _size;
    int _target;
}

- (id)initWithBytes:(const void *)bytes size:(int)size type:(GVboType)type;
- (int)size;
- (void)bind:(void(^)(void))blocks;
@end
