//
//  USKViewController.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKViewController.h"

#import "USKPageViewController.h"
#import "USKModelManager.h"
#import "USKFactoryPageViewController.h"
#import "USKPagesContext.h"

#import <QuartzCore/QuartzCore.h>

@implementation USKViewController
{
    IBOutlet UIScrollView *_baseScrollView;
    IBOutlet UIPageControl *_pageControl;
    
    EAGLContext *_context;
    
    USKModelManager *_modelManager;
    
    //if visible page is instanced, otherwise NSNull
    NSMutableArray *_pageViewControllers;
    USKFactoryPageViewController *_factoryPageViewController;
    
    NSFetchedResultsController *_fetchedResultsController;
    
    USKPagesContext *_pagesContext;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize blocksize = _baseScrollView.bounds.size;
    
    _modelManager = [[USKModelManager alloc] init];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_context];
    
    //描画コンテキスト
    _pagesContext = [[USKPagesContext alloc] initWithSize:blocksize];
    
    _baseScrollView.delegate = self;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.016
                                             target:self
                                           selector:@selector(onUpdate:)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSFetchRequest *fetchReuqest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([USKPage class])];
    fetchReuqest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchReuqest
                                                                    managedObjectContext:_modelManager.context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:@"pages"];
    _fetchedResultsController.delegate = self;
    NSError *error;
    [_fetchedResultsController performFetch:&error];
    NSAssert(error == nil, @"");
    
    _pageViewControllers = [NSMutableArray array];
    NSArray *fetchedObjects = _fetchedResultsController.fetchedObjects;
    for(int i = 0 ; i < fetchedObjects.count ; ++i)
    {
        USKPage *page = fetchedObjects[i];
        //normalize order
        page.order = @(i);
        
        //object add
        [_pageViewControllers addObject:[NSNull null]];
    }
    [_modelManager save];
    _pageControl.numberOfPages = fetchedObjects.count + 1;
    
    //最後のページ
    _factoryPageViewController = [[USKFactoryPageViewController alloc] initWithSize:blocksize
                                                                       modelManager:_modelManager];
    _factoryPageViewController.view.frame = CGRectMake(blocksize.width * _pageViewControllers.count, 0, blocksize.width, blocksize.height);
    [_baseScrollView addSubview:_factoryPageViewController.view];
    
    //全体幅
    _baseScrollView.contentSize = CGSizeMake(blocksize.width * (_pageViewControllers.count + 1), blocksize.height);
    
    //加速度センサー
    [UIAccelerometer sharedAccelerometer].delegate = self;
    [UIAccelerometer sharedAccelerometer].updateInterval = 0.1;
    
    [self updateActivationPages];
}
- (void)updateActivationPages
{
    NSArray *fetchedObjects = _fetchedResultsController.fetchedObjects;
    NSAssert(_pageViewControllers.count == fetchedObjects.count, @"");
    
    CGSize blocksize = _baseScrollView.bounds.size;
    
    CGRect visibleRect;
    visibleRect.origin = _baseScrollView.contentOffset;
    visibleRect.size = _baseScrollView.bounds.size;
    
    for(int i = 0 ; i < _pageViewControllers.count ; ++i)
    {
        CGRect thisRect = CGRectMake(blocksize.width * i, 0, blocksize.width, blocksize.height);
        if(CGRectIntersectsRect(thisRect, visibleRect))
        {
            //visible
            if(_pageViewControllers[i] != [NSNull null])
            {
                //NOP
            }
            else
            {
                USKPage *page = fetchedObjects[i];
                USKPageViewController *pageController = [[USKPageViewController alloc] initWithSize:blocksize
                                                                                          glcontext:_context
                                                                                               page:page
                                                                                       modelManager:_modelManager
                                                                                       pagesContext:_pagesContext];
                pageController.view.frame = thisRect;
                [_baseScrollView addSubview:pageController.view];
                _pageViewControllers[i] = pageController;
            }
        }
        else
        {
            //invisible
            if(_pageViewControllers[i] != [NSNull null])
            {
                USKPageViewController *removeTarget = _pageViewControllers[i];
                [removeTarget.view removeFromSuperview];
                _pageViewControllers[i] = [NSNull null];
            }
            else
            {
                //NOP
            }
        }
    }
}

- (void)onUpdate:(CADisplayLink *)sender
{
    //パフォーマンス上の事情で一番見えてるやつだけ
    CGRect visibleRect;
    visibleRect.origin = _baseScrollView.contentOffset;
    visibleRect.size = _baseScrollView.bounds.size;
    
    float maxVisibly = 0;
    USKPageViewController *maxVisiblyPageController = nil;
    for(int i = 0 ; i < _pageViewControllers.count ; ++i)
    {
        if(_pageViewControllers[i] != [NSNull null])
        {
            USKPageViewController *pageController = _pageViewControllers[i];
            CGRect visible = CGRectIntersection(visibleRect, pageController.view.frame);
            
            if(maxVisibly < visible.size.width)
            {
                maxVisibly = visible.size.width;
                maxVisiblyPageController = pageController;
            }
        }
    }
    
    [maxVisiblyPageController update];
}
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    CGSize blocksize = _baseScrollView.bounds.size;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
        {
            int newIndex = newIndexPath.row;
            USKPageViewController *pageController = [[USKPageViewController alloc] initWithSize:blocksize
                                                                              glcontext:_context
                                                                                   page:anObject
                                                                           modelManager:_modelManager
                                                                           pagesContext:_pagesContext];
            [_pageViewControllers insertObject:pageController atIndex:newIndex];
            
            pageController.view.frame = CGRectMake(blocksize.width * (_pageViewControllers.count - 1), 0, blocksize.width, blocksize.height);
            [_baseScrollView addSubview:pageController.view];
            
            //常に最後だけずらせばいい
            [UIView animateWithDuration:0.5 animations:^{
                _factoryPageViewController.view.frame = CGRectMake(blocksize.width * _pageViewControllers.count, 0, blocksize.width, blocksize.height);
            }];
            _baseScrollView.contentSize = CGSizeMake(blocksize.width * (_pageViewControllers.count + 1), blocksize.height);
            
            //これ必須？
            [_baseScrollView bringSubviewToFront:_factoryPageViewController.view];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            int rmIndex = indexPath.row;
            
            //先に表示オブジェクトを消す
            USKPageViewController *rmPageController = _pageViewControllers[rmIndex];
            [_baseScrollView sendSubviewToBack:rmPageController.view];
            [_pageViewControllers removeObjectAtIndex:rmIndex];
            
            //隣をアニメーション
            USKPageViewController *rightPageController = nil;
            if(rmIndex < _pageViewControllers.count)
            {
                //右ページが存在した
                NSArray *fetchedObjects = _fetchedResultsController.fetchedObjects;
                USKPage *page = fetchedObjects[rmIndex];
                rightPageController = [[USKPageViewController alloc] initWithSize:blocksize
                                                                        glcontext:_context
                                                                             page:page
                                                                     modelManager:_modelManager
                                                                     pagesContext:_pagesContext];
                rightPageController.view.frame = CGRectMake(blocksize.width * (rmIndex + 1), 0, blocksize.width, blocksize.height);
                [_baseScrollView addSubview:rightPageController.view];
                _pageViewControllers[rmIndex] = rightPageController;
            }
            [UIView animateWithDuration:.5 animations:^{
                rightPageController.view.frame = CGRectMake(blocksize.width * rmIndex, 0, blocksize.width, blocksize.height);
                _factoryPageViewController.view.frame = CGRectMake(blocksize.width * _pageViewControllers.count, 0, blocksize.width, blocksize.height);
            } completion:^(BOOL finished) {
                //移動が終わってから消す
                [rmPageController.view removeFromSuperview];
            }];
            _baseScrollView.contentSize = CGSizeMake(blocksize.width * (_pageViewControllers.count + 1), blocksize.height);
            
            break;
        }
        case NSFetchedResultsChangeUpdate:
            //not implement
            break;
        case NSFetchedResultsChangeMove:
            //not implement
            break;
    }
    
    _pageControl.numberOfPages = _pageViewControllers.count + 1;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for(id pageController in _pageViewControllers)
    {
        if(pageController != [NSNull null])
        {
            [pageController closeKeyboard];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateActivationPages];
    
    //update page control
    CGSize blocksize = _baseScrollView.bounds.size;
    int index = (int)floorf(MAX((_baseScrollView.contentOffset.x + blocksize.width * 0.5f), 0) / blocksize.width);
    _pageControl.currentPage = index;
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    for(id pageController in _pageViewControllers)
    {
        if(pageController != [NSNull null])
        {
            //[pageController setDeviceAccelerate:GLKVector3Make(acceleration.x, acceleration.y, acceleration.z)];
            [pageController setDeviceAccelerate:GLKVector3Make(acceleration.x, acceleration.y, acceleration.z)];
        }
    }
}
@end
