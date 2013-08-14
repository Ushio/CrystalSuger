//
//  GFbo.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/05/24.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GStateManager;
@interface GFbo : NSObject
- (id)initWithWidth:(int)width height:(int)height;
- (void)bind:(void(^)(void))drawing;
- (GLuint)texture;
- (int)width;
- (int)height;
@end
