//
//  GMutableFbo.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/20.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVbo.h"
@interface GMutableVbo : GVbo
//byteにはNULLを許す
- (id)initWithBytes:(const void *)bytes size:(int)size type:(GVboType)type;

//書き換え 書き込みのみ
- (void)map:(void(^)(void *pLocked))scope;
@end
