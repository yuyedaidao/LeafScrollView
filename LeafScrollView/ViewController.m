//
//  ViewController.m
//  LeafScrollView
//
//  Created by Wang on 14-5-12.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    LeafScrollView *leaf = [[LeafScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:leaf];
    leaf.beginUpdatingBlock = ^(LeafScrollView *view){
        [self performSelector:@selector(endUpdating:) withObject:view afterDelay:2];
    };
    
    //自定义顶部视图，设置好长宽即可
    UIView *topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    topInfoView.backgroundColor = [UIColor orangeColor];
    
    leaf.topInfoView = topInfoView;
    
}
-(void)endUpdating:(LeafScrollView *)view{
    [view endUpdating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
