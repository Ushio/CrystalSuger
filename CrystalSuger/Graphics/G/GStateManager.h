//
//  GStateManager.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/05/24.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
/**
 * openglのステートをラップします
 * ここ以外のステート変更は絶対に避ける
 */

#import "GState.h"
@interface GStateManager : NSObject
@property (nonatomic, copy) GState *currentState;

@property (nonatomic, assign) GLKVector4 clearColor;
@property (nonatomic, assign) GLenum activeTexture;
@end
