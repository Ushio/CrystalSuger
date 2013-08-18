//
//  USKFactoryPage.m
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/13.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKFactoryPageViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "NSManagedObject+Helper.h"
#import "UIImage+PDF.h"
#import "USKUtility.h"

#import "USKBrowserViewController.h"
#import "USKPopupViewController.h"

@implementation USKFactoryPageViewController
{
    IBOutlet UIButton *_buttonWikipedia;
    IBOutlet UIButton *_buttonCopyleft;
    
    IBOutlet UIButton *_buttonPlus;
    
    IBOutlet UILabel *_label;
    
    CGSize _size;
    USKModelManager *_modelManager;
    NSDate *_lastCreate;
    
    USKPopupViewController *_popup;
}
- (id)initWithSize:(CGSize)size modelManager:(USKModelManager *)modelManager
{
    if(self = [super initWithNibName:@"USKFactoryPage" bundle:nil])
    {
        _size = size;
        _modelManager = modelManager;
        
        //ベース
        self.view.frame = CGRectMake(0, 0, _size.width, _size.height);
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        NSString *wikipediaIconPath = [[NSBundle mainBundle] pathForResource:@"Wikipedia.pdf" ofType:@""];
        NSString *copyleftIconPath = [[NSBundle mainBundle] pathForResource:@"Copyleft.pdf" ofType:@""];
        NSString *addImagePath = [[NSBundle mainBundle] pathForResource:@"Add.pdf" ofType:@""];
        
        UIImage *wikipediaIcon = [UIImage imageWithContentsOfPDF:wikipediaIconPath height:_buttonWikipedia.bounds.size.height];
        UIImage *copyleftIcon = [UIImage imageWithContentsOfPDF:copyleftIconPath height:_buttonCopyleft.bounds.size.height];
        UIImage *addImage = [UIImage imageWithContentsOfPDF:addImagePath height:_buttonPlus.bounds.size.height];
        
        [_buttonWikipedia setImage:wikipediaIcon forState:UIControlStateNormal];
        _buttonWikipedia.backgroundColor = [UIColor clearColor];
        [_buttonCopyleft setImage:copyleftIcon forState:UIControlStateNormal];
        _buttonCopyleft.backgroundColor = [UIColor clearColor];
        
        _buttonPlus.bounds = CGRectMake(0, 0, addImage.size.width, addImage.size.height);
        [_buttonPlus setImage:addImage forState:UIControlStateNormal];
        _buttonPlus.backgroundColor = [UIColor clearColor];
        
        NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *line1 = [NSString stringWithFormat:@"%@ ver%@\n", NSLocalizedString(@"CrystalSuger", @"") ,versionString];
        NSString *line2 = @"Copyright (C) 2013 ushio All Rights Reserved.";
        
        NSMutableAttributedString *copyright = [[NSMutableAttributedString alloc] init];
        
        NSString *fontName = @"Avenir-BlackOblique";
        UIColor *textColor = [UIColor whiteColor];
        NSAttributedString *attLine1 = [[NSAttributedString alloc] initWithString:line1
                                                                       attributes:@{NSFontAttributeName : [UIFont fontWithName:fontName size:30],
                                                                                    NSForegroundColorAttributeName : textColor}];
        NSAttributedString *attLine2 = [[NSAttributedString alloc] initWithString:line2
                                                                       attributes:@{NSFontAttributeName : [UIFont fontWithName:fontName size:12],
                                                                                    NSForegroundColorAttributeName : textColor}];
        [copyright appendAttributedString:attLine1];
        [copyright appendAttributedString:attLine2];
        [_label setAttributedText:copyright];
        
        
        CAKeyframeAnimation *rAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        rAnimation.duration = 5.0f;
        rAnimation.repeatCount = FLT_MAX;
        int n = 10;
        NSMutableArray *values = [NSMutableArray array];
        for(int i = 0 ; i < n ; ++i)
        {
            float radian = [USKUtility remapValue:i iMin:0 iMax:n - 1 oMin:0 oMax:M_PI * 2.0];
            
            CATransform3D persp = CATransform3DIdentity;
            persp.m34 = 1.0f / -500.0f;
            persp = CATransform3DRotate(persp, radian, 0.0f, 1.0f, 0.0f);
            [values addObject:[NSValue valueWithCATransform3D:persp]];
        }
        rAnimation.values = values;
        rAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_label.layer addAnimation:rAnimation forKey:@"r"];
        
        _lastCreate = [[NSDate date] dateByAddingTimeInterval:-10];
    }
    return self;
}
- (IBAction)onButtonCreate:(UIButton *)sender
{
    if([[NSDate date] timeIntervalSinceDate:_lastCreate] > 1.0)
    {
        if(_modelManager.root.pages.count < 20)
        {
            USKPage *newPage = [USKPage createInstanceWithContext:_modelManager.context];
            NSNumber *max = [_modelManager.root.pages valueForKeyPath:@"@max.order"];
            newPage.order = @(max.intValue + 1);
            [_modelManager.root addPagesObject:newPage];
            [_modelManager save];
            
            _lastCreate = [NSDate date];
        }
        else
        {
            _popup = [[USKPopupViewController alloc] initWithMessage:NSLocalizedString(@"Can't create no more pages.", @"")];
            [_popup showWithCompletionHandler:^{
                _popup = nil;
            }];
        }
    }
}

- (IBAction)onButtonWikipedia:(id)sender {
    NSString *wikpediaString = NSLocalizedString(@"wikipedia", @"");
    NSURL *wikipediaURL = [NSURL URLWithString:wikpediaString];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"USKBrowser" bundle:nil];
    USKBrowserViewController *browserViewController = [storyboard instantiateInitialViewController];
    browserViewController.openURL = wikipediaURL;
    browserViewController.head = @"wikipedia";
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:browserViewController animated:YES completion:^{}];
}
- (IBAction)onButtonCopyleft:(id)sender {
    NSString *licencePath = [[NSBundle mainBundle] pathForResource:@"Licence.html" ofType:@""];
    NSURL *licenceURL = [NSURL fileURLWithPath:licencePath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"USKBrowser" bundle:nil];
    USKBrowserViewController *browserViewController = [storyboard instantiateInitialViewController];
    browserViewController.openURL = licenceURL;
    browserViewController.head = @"Licence";
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:browserViewController animated:YES completion:^{}];
}
@end
