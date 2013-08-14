//
//  USKLump.m
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/11.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKPageController.h"

#import <QuartzCore/QuartzCore.h>

#import "USKOpenGLView.h"
#import "USKNameField.h"
#import "UIImage+PDF.h"
#import "NSManagedObject+Helper.h"

#import "USKPhysicsWorld.h"
#import "USKPhysicsStaticMesh.h"
#import "USKPhysicsSphere.h"
#import "USKPhialCollisionVertices.h"
#import "USKUtility.h"
#import "USKCamera.h"

//http://iosfonts.com/

static const int HEADER_SIZE = 30;
static UIImage *rmImage = nil;

@interface USKPageController()
@property (strong, nonatomic) UIView *view;
@end
@implementation USKPageController
{
    CGSize _size;
    
    EAGLContext *_glcontext;
    USKOpenGLView *_glview;
    USKNameField *_nameField;
    UILabel *_countLabel;
    
    USKPage *_page;
    USKModelManager *_modelManager;
    USKPagesContext *_pagesContext;
    
    USKPhysicsWorld *_physicsWorld;
    
    USKCamera *_camera;
    
    NSDate *_beginTime;
    double _lastUpdateTime;
    double _integralTime;
    
    BOOL _isRemoved;
}
- (id)initWithSize:(CGSize)size
         glcontext:(EAGLContext *)glcontext
              page:(USKPage *)page
      modelManager:(USKModelManager *)modelManager
      pagesContext:(USKPagesContext *)pagesContext
{
    if(self = [super init])
    {
        _size = size;
        _glcontext = glcontext;
        _page = page;
        _modelManager = modelManager;
        _pagesContext = pagesContext;
        
        //ベース
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
        
        _glview = [[USKOpenGLView alloc] initWithFrame:self.view.bounds
                                               context:_glcontext];
        [self.view addSubview:_glview];
        
        //テキスト
        _nameField = [[USKNameField alloc] initWithFrame:CGRectMake(HEADER_SIZE, 0, _size.width - HEADER_SIZE, HEADER_SIZE)];
        _nameField.text = page.name;
        _nameField.delegate = self;
        [self.view addSubview:_nameField];
        
        //ボタン
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *rmImagePath = [[NSBundle mainBundle] pathForResource:@"RemoveButton.pdf" ofType:@""];
            rmImage = [UIImage imageWithContentsOfPDF:rmImagePath height:HEADER_SIZE];
        });

        UIButton *rmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rmButton.frame = CGRectMake(0, 0, HEADER_SIZE, HEADER_SIZE);
        [rmButton setImage:rmImage forState:UIControlStateNormal];
        [rmButton addTarget:self action:@selector(onRemoveButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rmButton];
        
        //カウンター
        _countLabel = [[UILabel alloc] init];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont fontWithName:@"Futura-MediumItalic" size:25];
        _countLabel.frame = CGRectMake(10, HEADER_SIZE + 4, 50, 30);
        _countLabel.text = [NSString stringWithFormat:@"%d", _page.count.intValue];
        [self.view addSubview:_countLabel];
        
        //物理エンジン
        _physicsWorld = [[USKPhysicsWorld alloc] init];
        
        //テスト瓶
        USKPhysicsStaticMesh *mesh = [[USKPhysicsStaticMesh alloc] initWithTriMesh:kPhialCollisionVertices numberOfVertices:ARRAY_SIZE(kPhialCollisionVertices)];
        [_physicsWorld addPhysicsObject:mesh];
        
        //カメラ
        _camera = [[USKCamera alloc] init];
        
        
        //タップ
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onTap:)];
        [_glview addGestureRecognizer:tapGestureRecognizer];
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                                 action:@selector(onLongPress:)];
        [_glview addGestureRecognizer:longPressGestureRecognizer];
        
        _beginTime = [NSDate date];
        _lastUpdateTime = 0.0;
        _integralTime = 0.0;
    }
    return self;
}

//ちょっと後で
- (void)setIsActivated:(BOOL)isActivated
{
    
}
- (BOOL)isActivated
{
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeKeyboard];
    return YES;
}
- (void)onRemoveButton:(UIButton *)button
{
    //一応
    if(_isRemoved == NO)
    {
        [_page destroyInstance];
        _isRemoved = YES;
    }
}
- (void)updateCountLabel
{
    [UIView transitionWithView:_countLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _countLabel.text = [NSString stringWithFormat:@"%d", _page.count.intValue];
    } completion:^(BOOL finished) {}];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer
{
    _page.count = @(_page.count.intValue + 1);
    [_modelManager save];
    [self updateCountLabel];
    
    USKPhysicsSphere *sphere = [[USKPhysicsSphere alloc] init];
    sphere.position = GLKVector3Make(0.0f, 0.3f, 0.0f);
    
    [_pagesContext.queue addOperationWithBlock:^{
        [_physicsWorld addPhysicsObject:sphere];
    }];
}
- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        if(_page.count.intValue > 0)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:@"キャンセル"
                                                       destructiveButtonTitle:@"すべて削除"
                                                            otherButtonTitles:@"１つ削除", nil];
            [actionSheet showInView:_view];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        //すべて削除
        _page.count = @0;
    }
    else
    {
        _page.count = @(_page.count.intValue - 1);
    }
    [self updateCountLabel];
}
- (void)update
{
    double elapsed = [[NSDate date] timeIntervalSinceDate:_beginTime];
    double delta = elapsed - _lastUpdateTime;
    _lastUpdateTime = elapsed;
    
    float aspect = _size.width / _size.height;
    
    //時間が進みすぎないようにセーブする
    delta = MIN(delta, 1.0 / 30.0);
    
    _integralTime += delta;
    
    //カメラ
    GLKVector3 p = GLKVector3Make(0, 1, 2);
    GLKMatrix3 m = GLKMatrix3MakeYRotation(_integralTime * 0.1f);
    _camera.aspect = aspect;
    _camera.position = GLKMatrix3MultiplyVector3(m, p);
    _camera.lookAt = GLKVector3Make(0, 0, 0);
    
    //レンダリング
    glBindFramebuffer(GL_FRAMEBUFFER, _glview.framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _glview.colorRenderbuffer);
    
    glViewport(0, 0, _glview.glBufferWidth, _glview.glBufferHeight);
    GStateManager *sm = _pagesContext.stateManager;
    sm.currentState = nil;
    sm.clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    [_pagesContext.postEffectFbo bind:^{
        glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
        
        [_pagesContext.backgroundRenderer renderWithAspect:aspect sm:sm];
        [_pagesContext.starRenderer renderAtTime:_integralTime aspect:aspect sm:sm];
        
        [_pagesContext.queue waitUntilAllOperationsAreFinished];
        {
            [_physicsWorld renderForDebug:sm camera:_camera];
            
        }
        [_pagesContext.queue addOperationWithBlock:^{
            [_physicsWorld stepWithDeltaTime:delta];
        }];
    }];

    [_pagesContext.postEffect renderWithTexture:_pagesContext.postEffectFbo.texture sm:sm];
    [_glcontext presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)closeKeyboard
{
    [_nameField resignFirstResponder];
    _page.name = _nameField.text;
    [_modelManager save];
}
@end
