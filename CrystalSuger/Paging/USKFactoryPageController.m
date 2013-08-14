//
//  USKFactoryPage.m
//  BaseStudy
//
//  Created by ushiostarfish on 2013/08/13.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#import "USKFactoryPageController.h"

#import "NSManagedObject+Helper.h"

@interface USKFactoryPageController()
@property (strong, nonatomic) UIView *view;
@end
@implementation USKFactoryPageController
{
    CGSize _size;
    USKModelManager *_modelManager;
    NSDate *_lastCreate;
}
- (id)initWithSize:(CGSize)size modelManager:(USKModelManager *)modelManager
{
    if(self = [super init])
    {
        _size = size;
        _modelManager = modelManager;
        
        //ベース
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
        _view.backgroundColor = [UIColor blackColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, 100, 30);
        [button setTitle:@"new" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onCreate:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        _lastCreate = [[NSDate date] dateByAddingTimeInterval:-10];
    }
    return self;
}
- (void)onCreate:(UIButton *)sender
{
    if([[NSDate date] timeIntervalSinceDate:_lastCreate] > 1.0)
    {
        USKPage *newPage = [USKPage createInstanceWithContext:_modelManager.context];
        NSNumber *max = [_modelManager.root.pages valueForKeyPath:@"@max.order"];
        newPage.order = @(max.intValue + 1);
        [_modelManager.root addPagesObject:newPage];
        [_modelManager save];
        
        _lastCreate = [NSDate date];
    }
}
@end
