//
//  USKNameField.m
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/05.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

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
