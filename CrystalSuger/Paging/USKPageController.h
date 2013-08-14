//
//  USKLump.h
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/11.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USKPage.h"
#import "USKModelManager.h"
#import "USKPagesContext.h"

@interface USKPageController : NSObject<UITextFieldDelegate, UIActionSheetDelegate>
- (id)initWithSize:(CGSize)size
         glcontext:(EAGLContext *)glcontext
              page:(USKPage *)page
      modelManager:(USKModelManager *)modelManager
      pagesContext:(USKPagesContext *)pagesContext;

@property (strong, nonatomic, readonly) UIView *view;

@property (nonatomic, assign) BOOL isActivated;
- (void)update;
- (void)closeKeyboard;
@end
