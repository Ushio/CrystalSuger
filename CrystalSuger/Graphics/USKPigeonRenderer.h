//
//  USKPigeonRenderer.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/17.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
#import "USKCameraProtocol.h"

@interface USKPigeonRenderer : NSObject
- (void)renderWithCamera:(id<USKCameraProtocol>)camera parent:(GLKMatrix4)parent sm:(GStateManager *)sm;
@end
