//
//  USKGraphicsContext.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKPagesContext.h"

#import "GMSAAFbo.h"
@implementation USKPagesContext
- (id)initWithSize:(CGSize)size
{
    if(self = [super init])
    {
        _stateManager = [[GStateManager alloc] init];
        _backgroundRenderer = [[USKBackgroundRenderer alloc] init];
        _starRenderer = [[USKStarRenderer alloc] init];
        _kompeitoRenderer = [[USKKompeitoRenderer alloc] init];
        
        _phialBodyRenderer = [[USKPhialBodyRenderer alloc] init];
        
        _postEffectFbo = [[GMSAAFbo alloc] initWithWidth:size.width height:size.height];
        _postEffect = [[USKPostEffect alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}
@end
