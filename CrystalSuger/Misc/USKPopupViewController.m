//
//  USKPopupViewController.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/18.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKPopupViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation USKPopupViewController
{
    IBOutlet UIView *_background;
    IBOutlet UILabel *_label;
    IBOutlet UIButton *_button;
    
    NSString *_message;
    
    UIView *_darknessView;
    
    void (^_completion)();
    
    BOOL _closed;
}
-(id)initWithMessage:(NSString *)message
{
    if(self = [super initWithNibName:@"USKPopup" bundle:nil])
    {
        _message = message;
    }
    return self;
}
- (void)viewDidLoad
{
    _background.layer.cornerRadius = 10.0;
    UIBezierPath *backgroundShadowPath = [UIBezierPath bezierPathWithRoundedRect:_background.layer.bounds
                                                                    cornerRadius:_background.layer.cornerRadius];
    _background.layer.shadowPath = backgroundShadowPath.CGPath;
    UIColor *backgroundShadowColor = [UIColor whiteColor];
    _background.layer.shadowColor = backgroundShadowColor.CGColor;
    _background.layer.shadowOffset = CGSizeMake(0, 0);
    _background.layer.shadowRadius = 5.0f;
    _background.layer.shadowOpacity = 1.0f;
    
    UIBezierPath *buttonShadowPath = [UIBezierPath bezierPathWithRoundedRect:_button.layer.bounds
                                                                cornerRadius:_button.layer.cornerRadius];
    _button.layer.shadowPath = buttonShadowPath.CGPath;
    UIColor *buttonShadowColor = [UIColor blackColor];
    _button.layer.shadowColor = buttonShadowColor.CGColor;
    _button.layer.shadowOffset = CGSizeMake(0, 2);
    _button.layer.shadowRadius = 3.0f;
    _button.layer.shadowOpacity = 0.5f;
    
    _label.text = _message;
}
- (IBAction)onOK:(UIButton *)sender
{
    if(_closed == NO)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^
        {
            self.view.alpha = 0.0f;
            self.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            _darknessView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [_darknessView removeFromSuperview];
            
            if(_completion)
            {
                _completion();
                _completion = nil;
            }
        }];
        
        _closed = YES;
    }
}
- (void)showWithCompletionHandler:(void(^)())completion
{
    _completion = [completion copy];
    
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    
    _darknessView = [[UIView alloc] initWithFrame:rootView.bounds];
    _darknessView.backgroundColor = [UIColor blackColor];
    _darknessView.alpha = 0.0f;
    [rootView addSubview:_darknessView];
    
    self.view.center = CGPointMake(rootView.bounds.size.width * 0.5f, rootView.bounds.size.height * 0.5f);
    [rootView addSubview:self.view];
    
    self.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
    {
        self.view.transform = CGAffineTransformIdentity;
        self.view.alpha = 1.0f;
        _darknessView.alpha = 0.5f;
    } completion:^(BOOL finished) {
    }];
}
@end
