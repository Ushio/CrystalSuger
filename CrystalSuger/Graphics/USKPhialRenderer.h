//
//  USKPhialBodyRenderer.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/15.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
#import "USKCameraProtocol.h"

@interface USKPhialRenderer : NSObject
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm;
@end
