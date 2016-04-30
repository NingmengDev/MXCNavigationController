//
//  PushViewController.m
//  MXCNavigationController
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "PushViewController.h"

#import "MXCNavigationController/MXCNavigationController.h"

#import <Masonry/Masonry.h>

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.class description];
    
    /**
     *  自定义导航栏右边按钮
     */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemEvent:)];
    
    /**
     *  禁用导航栏的全屏pod手势
     */
//    [self.navigationController setValue:@(NO) forKey:@"interactivePopGestureRecognizerEnabled"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)rightBarButtonItemEvent:(UIBarButtonItem *)item
{
    NSLog(@"点击了导航栏右边的按钮。");
}

@end
