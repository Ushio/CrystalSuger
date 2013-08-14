//
//  USKGraphicsContext.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
#import "USKBackgroundRenderer.h"
#import "USKStarRenderer.h"
#import "USKKompeitoRenderer.h"
#import "GFbo.h"
#import "USKPostEffect.h"

@interface USKPagesContext : NSObject
@property (strong, nonatomic, readonly) GStateManager *stateManager;
@property (strong, nonatomic, readonly) USKBackgroundRenderer *backgroundRenderer;
@property (strong, nonatomic, readonly) USKStarRenderer *starRenderer;
@property (strong, nonatomic, readonly) USKKompeitoRenderer *kompeitoRenderer;
@property (strong, nonatomic, readonly) GFbo *postEffectFbo;
@property (strong, nonatomic, readonly) USKPostEffect *postEffect;
@property (strong, nonatomic, readonly) NSOperationQueue *queue;
- (id)initWithSize:(CGSize)size;
@end
