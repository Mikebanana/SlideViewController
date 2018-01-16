//
//  ViewController.m
//  LYSlidePageViewControllerDemo
//
//  Created by discover on 2018/1/16.
//  Copyright © 2018年 fengzhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"项目信息",@"相关资料",@"投资记录"];
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor yellowColor];
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor blueColor];
    self.controllerArray = @[vc1,vc2,vc3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
