//
//  USKViewController.m
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKViewController.h"

#import "USKPageController.h"
#import "USKModelManager.h"
#import "USKFactoryPageController.h"
#import "USKPagesContext.h"

#import <QuartzCore/QuartzCore.h>

@implementation USKViewController
{
    IBOutlet UIScrollView *_baseScrollView;
    
    EAGLContext *_context;
    
    USKModelManager *_modelManager;
    
    NSMutableArray *_pageControllers;
    USKFactoryPageController *_factoryPageController;
    
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
    
    _pageControllers = [NSMutableArray array];
    NSArray *fetchedObjects = _fetchedResultsController.fetchedObjects;
    for(int i = 0 ; i < fetchedObjects.count ; ++i)
    {
        USKPage *page = fetchedObjects[i];
        USKPageController *pageController = [[USKPageController alloc] initWithSize:blocksize
                                                                          glcontext:_context
                                                                               page:page
                                                                       modelManager:_modelManager
                                                                       pagesContext:_pagesContext];
        [_pageControllers addObject:pageController];
        pageController.view.frame = CGRectMake(blocksize.width * i, 0, blocksize.width, blocksize.height);
        [_baseScrollView addSubview:pageController.view];
    }
    
    //最後のページ
    _factoryPageController = [[USKFactoryPageController alloc] initWithSize:blocksize
                                                               modelManager:_modelManager];
    _factoryPageController.view.frame = CGRectMake(blocksize.width * _pageControllers.count, 0, blocksize.width, blocksize.height);
    [_baseScrollView addSubview:_factoryPageController.view];
    
    //全体幅
    _baseScrollView.contentSize = CGSizeMake(blocksize.width * (_pageControllers.count + 1), blocksize.height);

    //描画コンテキスト
    _pagesContext = [[USKPagesContext alloc] initWithSize:blocksize];
}
- (void)onUpdate:(CADisplayLink *)sender
{
    //パフォーマンス上の事情で一番見えてるやつだけ
    CGRect visibleRect;
    visibleRect.origin = _baseScrollView.contentOffset;
    visibleRect.size = _baseScrollView.bounds.size;
    
    float maxVisibly = 0;
    USKPageController *maxVisiblyPageController = nil;
    for(int i = 0 ; i < _pageControllers.count ; ++i)
    {
        USKPageController *pageController = _pageControllers[i];
        CGRect visible = CGRectIntersection(visibleRect, pageController.view.frame);
        
        if(maxVisibly < visible.size.width)
        {
            maxVisibly = visible.size.width;
            maxVisiblyPageController = pageController;
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
            USKPageController *pageController = [[USKPageController alloc] initWithSize:blocksize
                                                                              glcontext:_context
                                                                                   page:anObject
                                                                           modelManager:_modelManager
                                                                           pagesContext:_pagesContext];
            [_pageControllers insertObject:pageController atIndex:newIndex];
            
            pageController.view.frame = CGRectMake(blocksize.width * (_pageControllers.count - 1), 0, blocksize.width, blocksize.height);
            [_baseScrollView addSubview:pageController.view];
            
            //常に最後だけずらせばいい
            [UIView animateWithDuration:0.5 animations:^{
                _factoryPageController.view.frame = CGRectMake(blocksize.width * _pageControllers.count, 0, blocksize.width, blocksize.height);
            }];
            _baseScrollView.contentSize = CGSizeMake(blocksize.width * (_pageControllers.count + 1), blocksize.height);
            
            //これ必須？
            [_baseScrollView bringSubviewToFront:_factoryPageController.view];
            
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            int rmIndex = indexPath.row;
            
            //先に表示オブジェクトを消す
            USKPageController *rmPageController = _pageControllers[rmIndex];
            [_baseScrollView sendSubviewToBack:rmPageController.view];
            [_pageControllers removeObjectAtIndex:rmIndex];
            
            //右のやつはすべて再配置
            [UIView animateWithDuration:.5 animations:^{
                for(int i = rmIndex ; i < _pageControllers.count ; ++i)
                {
                    USKPageController *replacePageController = _pageControllers[i];
                    replacePageController.view.frame = CGRectMake(blocksize.width * i, 0, blocksize.width, blocksize.height);
                }
                _factoryPageController.view.frame = CGRectMake(blocksize.width * _pageControllers.count, 0, blocksize.width, blocksize.height);
            } completion:^(BOOL finished) {
                //移動が終わってから消す
                [rmPageController.view removeFromSuperview];
            }];
            _baseScrollView.contentSize = CGSizeMake(blocksize.width * (_pageControllers.count + 1), blocksize.height);
            
            break;
        }
        case NSFetchedResultsChangeUpdate:
            //not implement
            break;
        case NSFetchedResultsChangeMove:
            //not implement
            break;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for(USKPageController *pageController in _pageControllers)
    {
        [pageController closeKeyboard];
    }
}
@end
