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

@interface USKPageViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate>
- (id)initWithSize:(CGSize)size
         glcontext:(EAGLContext *)glcontext
              page:(USKPage *)page
      modelManager:(USKModelManager *)modelManager
      pagesContext:(USKPagesContext *)pagesContext;

- (void)update;
- (void)closeKeyboard;
- (void)setDeviceAccelerate:(GLKVector3)accelerate;
@end
