/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "USKNameField.h"

@implementation USKNameField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor colorWithWhite:0.098 alpha:1.000];
        self.textAlignment = NSTextAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.font = [UIFont systemFontOfSize:20];
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect border = CGRectInset(self.bounds, 3, 3);
    [UIColor whiteColor];
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:border cornerRadius:5];
    [[UIColor whiteColor] set];
    bezier.lineWidth = 2;
    [bezier fill];
}

@end
