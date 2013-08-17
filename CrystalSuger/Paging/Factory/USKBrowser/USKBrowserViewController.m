//
//  USKBrowserViewController.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/15.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKBrowserViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation USKBrowserViewController
{
    IBOutlet UINavigationItem *_titleItem;
    IBOutlet UIWebView *_webView;
    IBOutlet UIBarButtonItem *_backButton;
    IBOutlet UIBarButtonItem *_forwardButton;
    
    UIImageView *_indicatorView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleItem.title = self.head;
    
    NSMutableArray *loadingImages = [NSMutableArray array];
    for(int i = 0 ; i < 10 ; ++i)
    {
        NSString *name = [NSString stringWithFormat:@"loading/image%d.png", i];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [loadingImages addObject:image];
    }
    
    _indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
    _indicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _indicatorView.layer.cornerRadius = 10;
    _indicatorView.center = CGPointMake(self.view.bounds.size.width * 0.5f, self.view.bounds.size.height * 0.5f);
    _indicatorView.animationImages = loadingImages;
    _indicatorView.animationDuration = 1.0f;
    [_indicatorView startAnimating];
    [self.view addSubview:_indicatorView];
    
    
    //webview
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.openURL];
    [_webView loadRequest:request];
    
    _webView.userInteractionEnabled = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)dealloc
{
    _webView.delegate = nil;
}
- (IBAction)done:(id)sender
{
    [_webView stopLoading];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.onClosed)
            self.onClosed();
    }];
}
- (IBAction)back:(id)sender
{
    [_webView goBack];
}
- (IBAction)forward:(id)sender
{
    [_webView goForward];
}
- (IBAction)refresh:(id)sender
{
    [_webView reload];
}
- (IBAction)action:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Open in Safari", @""), nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSString *urlString = [_webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)wv
{
    _indicatorView.hidden = NO;
    _indicatorView.alpha = 1.0;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    [UIView animateWithDuration:0.5 animations:^{
        _indicatorView.alpha = 0;
    }];
    
    _backButton.enabled = [_webView canGoBack];
    _forwardButton.enabled = [_webView canGoForward];
    
    _webView.userInteractionEnabled = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    [UIView animateWithDuration:0.5 animations:^{
        _indicatorView.alpha = 0;
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *message = NSLocalizedString(@"failed to connect network", @"");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}
@end
