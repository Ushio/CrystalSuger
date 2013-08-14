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
    
    NSDate *_begin;
    
    BOOL _isRemoved;
}
- (id)initWithSize:(CGSize)size glcontext:(EAGLContext *)glcontext page:(USKPage *)page modelManager:(USKModelManager *)modelManager
{
    if(self = [super init])
    {
        _size = size;
        _glcontext = glcontext;
        _page = page;
        _modelManager = modelManager;
        
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
        
        //タップ
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(onTap:)];
        [_glview addGestureRecognizer:tapGestureRecognizer];
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                                 action:@selector(onLongPress:)];
        [_glview addGestureRecognizer:longPressGestureRecognizer];
        
        _begin = [NSDate date];
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
    double elapsed = [[NSDate date] timeIntervalSinceDate:_begin];
    
    glBindFramebuffer(GL_FRAMEBUFFER, _glview.framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _glview.colorRenderbuffer);
    
    float b = sin(elapsed) * 0.5 + 0.5;
    glClearColor(b * 0.5f, b * 0.5f, b * 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_glcontext presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)closeKeyboard
{
    [_nameField resignFirstResponder];
    _page.name = _nameField.text;
    [_modelManager save];
}
@end
