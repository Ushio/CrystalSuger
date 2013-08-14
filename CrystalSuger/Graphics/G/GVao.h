//
//  GVao.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/27.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVao : NSObject
- (void)bind:(void(^)(void))blocks;
@end
