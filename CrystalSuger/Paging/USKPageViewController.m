//
//  USKLump.m
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/11.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKPageViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "USKOpenGLView.h"
#import "USKNameField.h"
#import "UIImage+PDF.h"
#import "NSManagedObject+Helper.h"

#import "USKPhysicsWorld.h"
#import "USKPhysicsStaticMesh.h"
#import "USKKompeitoSphere.h"
#import "USKKompeitoSphere.h"
#import "USKPhialCollisionVertices.h"
#import "USKUtility.h"
#import "USKCamera.h"

#import "USKKompeito.h"
#import "USKKompeitoConstants.h"

#import "USKPopupViewController.h"

//TODO 最大数
//http://iosfonts.com/

static const int HEADER_SIZE = 30;
static UIImage *rmImage = nil;

@implementation USKPageViewController
{
    CGSize _size;
    
    EAGLContext *_glcontext;
    USKOpenGLView *_glview;
    USKNameField *_nameField;
    UILabel *_countLabel;
    
    int _count;
    USKPage *_page;
    USKModelManager *_modelManager;
    USKPagesContext *_pagesContext;
    
    USKPhysicsWorld *_physicsWorld;
    NSMutableArray *_kompeitoSpheres;
    GLKVector3 _gravity;
    
    USKCamera *_camera;
    
    USKPopupViewController *_popup;
    
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
        
        NSAssert(glcontext, @"");
        NSAssert(page, @"");
        NSAssert(modelManager, @"");
        NSAssert(pagesContext, @"");
        
        //ベース
        self.view.frame = CGRectMake(0, 0, _size.width, _size.height);
        
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
            NSString *rmImagePath = [[NSBundle mainBundle] pathForResource:@"RemoveIcon.pdf" ofType:@""];
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
        _countLabel.text = [NSString stringWithFormat:@"%d", _page.kompeitos.count];
        [self.view addSubview:_countLabel];
        
        //物理エンジン
        _physicsWorld = [[USKPhysicsWorld alloc] init];
        _kompeitoSpheres = [NSMutableArray array];
        
        //テスト瓶
        USKPhysicsStaticMesh *mesh = [[USKPhysicsStaticMesh alloc] initWithTriMesh:kPhialCollisionVertices numberOfVertices:ARRAY_SIZE(kPhialCollisionVertices)];
        [_physicsWorld addPhysicsObject:mesh];
//        GLKVector3 aabbMin, aabbMax;
//        [mesh aabbMin:&aabbMin max:&aabbMax];
        
        //リストア
        for(USKKompeito *kompeito in _page.kompeitos)
        {
            //物理エンジンに反映
            USKKompeitoSphere *ksphere = [[USKKompeitoSphere alloc] initWithPosition:GLKVector3Make(kompeito.x.floatValue, kompeito.y.floatValue, kompeito.z.floatValue)];
            ksphere.color = kompeito.color.intValue;
            
            [_physicsWorld addPhysicsObject:ksphere];
            [_kompeitoSpheres addObject:ksphere];
        }
        _count = _page.kompeitos.count;
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [self update];
    }
    return self;
}
- (void)dealloc
{
    if(_isRemoved == NO)
    {
        [self saveKompeito];
    }
    
    [_pagesContext.queue waitUntilAllOperationsAreFinished];
    for(USKKompeitoSphere *ksphere in _kompeitoSpheres)
    {
        [ksphere removeFromWorld];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
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
        [_modelManager save];
        
        _isRemoved = YES;
    }
}
- (void)updateCountLabel
{
    [UIView transitionWithView:_countLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _countLabel.text = [NSString stringWithFormat:@"%d", _count];
    } completion:^(BOOL finished) {}];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer
{    
    if(_count < kMaxKompeito)
    {
        _count++;
        [self updateCountLabel];
        
        USKKompeitoSphere *ksphere = [[USKKompeitoSphere alloc] init];
        ksphere.position = GLKVector3Make(0.0f, 0.3f, 0.0f);
        ksphere.color = random_kompeito_selection();
        
        [_pagesContext.queue waitUntilAllOperationsAreFinished];
        [_physicsWorld addPhysicsObject:ksphere];
        [_kompeitoSpheres addObject:ksphere];
    }
    else
    {
        _popup = [[USKPopupViewController alloc] initWithMessage:NSLocalizedString(@"The phial is full of Kompeito.", @"")];
        [_popup showWithCompletionHandler:^{
            _popup = nil;
        }];
    }
}
- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        if(_count > 0)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                       destructiveButtonTitle:NSLocalizedString(@"Remove All", @"")
                                                            otherButtonTitles:NSLocalizedString(@"Remove One", @""), nil];
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        //すべて削除
        _count = 0;
        
        [_pagesContext.queue waitUntilAllOperationsAreFinished];
        for(USKKompeitoSphere *ksphere in _kompeitoSpheres)
        {
            [ksphere removeFromWorld];
        }
        [_kompeitoSpheres removeAllObjects];
    }
    else if(buttonIndex != actionSheet.cancelButtonIndex)
    {
        //一つ削除
        _count--;
        
        USKKompeitoSphere *ksphere = _kompeitoSpheres.lastObject;
        
        [_pagesContext.queue waitUntilAllOperationsAreFinished];
        [ksphere removeFromWorld];
        [_kompeitoSpheres removeLastObject];
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
    GLKVector3 p = GLKVector3Make(0, 1.4, 2.5);
    GLKMatrix3 m = GLKMatrix3MakeYRotation(_integralTime * 0.1f);
    _camera.aspect = aspect;
    _camera.position = GLKMatrix3MultiplyVector3(m, p);
    _camera.lookAt = GLKVector3Make(0, 0.4, 0);
    _camera.fieldOfView = [USKUtility isIphone5]? 53 : 45;
    
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
            //[_physicsWorld renderForDebug:sm camera:_camera];
            [_pagesContext.kompeitoRenderer renderWithKompeitos:_kompeitoSpheres camera:_camera sm:sm];
        }
        
        GLKVector3 gravity = _gravity;
        [_pagesContext.queue addOperationWithBlock:^{
            [_physicsWorld setGravity:gravity];
            [_physicsWorld stepWithDeltaTime:delta];
        }];
        
        [_pagesContext.phialBodyRenderer renderWithCamera:_camera sm:sm];
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
- (void)saveKompeito
{
    //同期
    [_pagesContext.queue waitUntilAllOperationsAreFinished];
    
    //一度クリア
    for(USKKompeito *kompeito in _page.kompeitos)
    {
        [kompeito destroyInstance];
    }
    
    //再構成
    for(USKKompeitoSphere *ksphere in _kompeitoSpheres)
    {
        USKKompeito *kompeito = [USKKompeito createInstanceWithContext:_modelManager.context];
        GLKVector3 position = ksphere.position;
        kompeito.x = @(position.x);
        kompeito.y = @(position.y);
        kompeito.z = @(position.z);
        kompeito.color = @(ksphere.color);
        kompeito.page = _page;
    }
    
    [_modelManager save];
}
- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self saveKompeito];
}

- (void)setDeviceAccelerate:(GLKVector3)accelerate
{
    const float THREASHOLD = 0.1f;
    if(GLKVector3Length(accelerate) > THREASHOLD)
    {
        GLKVector3 x = GLKVector3MultiplyScalar(_camera.right, accelerate.x);
        GLKVector3 y = GLKVector3MultiplyScalar(_camera.up, accelerate.y);
        GLKVector3 z = GLKVector3MultiplyScalar(_camera.back, accelerate.z);
        GLKVector3 direction = GLKVector3Normalize(GLKVector3Add(x, GLKVector3Add(y, z)));
        _gravity = GLKVector3MultiplyScalar(direction, 9.8f);
    }
    else
    {
        _gravity = GLKVector3Make(0, 0, 0);
    }
}
@end
