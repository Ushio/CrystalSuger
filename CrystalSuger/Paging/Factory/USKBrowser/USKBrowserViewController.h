//
//  USKBrowserViewController.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/15.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USKBrowserViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) NSURL *openURL;
@property (strong, nonatomic) NSString *head;

@property (nonatomic, copy) void (^onClosed)();
@end
