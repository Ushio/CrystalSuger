//
//  GTexture.h
//  iCrystalSuger
//
//  Created by 吉村 篤 on 2013/03/31.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTexture : NSObject
- (id)initWithContentsOfFile:(NSString *)path
               interpolation:(int)interpolation
                        wrap:(int)wrap;
- (unsigned)name;
@end
