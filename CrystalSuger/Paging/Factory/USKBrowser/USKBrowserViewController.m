/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "USKBrowserViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "USKPopupViewController.h"


@implementation USKBrowserViewController
{
    IBOutlet UINavigationItem *_titleItem;
    IBOutlet UIWebView *_webView;
    IBOutlet UIBarButtonItem *_backButton;
    IBOutlet UIBarButtonItem *_forwardButton;
    
    UIImageView *_indicatorView;
    
    USKPopupViewController *_popup;
    BOOL _closed;
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
    if(_closed == NO)
    {
        _closed = YES;
        [_webView stopLoading];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
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
    if(_closed == NO)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _indicatorView.alpha = 0;
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        _popup = [[USKPopupViewController alloc] initWithMessage:NSLocalizedString(@"Failed to connect network", @"")];
        [_popup showWithCompletionHandler:^{
            _popup = nil;
        }];
    }
}
@end
