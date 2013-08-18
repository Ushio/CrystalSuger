//
//  USKPopupViewController.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/18.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USKPopupViewController : UIViewController
-(id)initWithMessage:(NSString *)message;
- (void)showWithCompletionHandler:(void(^)())completion;
@end
