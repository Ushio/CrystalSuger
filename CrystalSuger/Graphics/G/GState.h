//
//  GStateManager.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/21.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GState : NSObject<NSCopying>
@property (nonatomic, assign) BOOL blend;
@property (nonatomic, assign) GLenum blend_sfactor;
@property (nonatomic, assign) GLenum blend_dfactor;

@property (nonatomic, assign) BOOL depthTest;
@property (nonatomic, assign) BOOL depthWrite;

@property (nonatomic, assign) BOOL cullFace;
@property (nonatomic, assign) GLenum cullFaceMode;

@end