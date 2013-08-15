//
//  KompeitoRenderer.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GStateManager.h"
#import "USKCameraProtocol.h"

@interface USKKompeitoRenderer : NSObject
- (void)renderWithKompeitos:(NSArray *)kompeitos camera:(id<USKCameraProtocol>)camera sm:(GStateManager *)sm;
@end
