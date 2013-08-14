//
//  USKAddEffectRenderer.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/06/02.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USKCameraProtocol.h"
#import "GStateManager.h"
@interface USKAddEffectRenderer : NSObject
- (void)update;
- (void)renderWithCamera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm;
@end
