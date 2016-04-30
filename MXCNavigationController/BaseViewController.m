//
//  BaseViewController.m
//  MXCNavigationController
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "BaseViewController.h"

#import "MXCNavigationController/MXCNavigationContainer.h"
#import "MainViewController.h"
#import "PushViewController.h"

#import <Masonry/Masonry.h>

/**
 *  随机颜色
 *
 *  @return 随机颜色
 */
extern UIColor *MXTRandomColor()
{
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    CGFloat alpha = arc4random() % 256 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [self.class description];
    
    /**
     *  设置导航栏的颜色，各个viewController的导航栏之间不相互影响
     */
    self.navigationController.navigationBar.barTintColor = MXTRandomColor();
    
    [self createButtonsBaseNavViewControllers];
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

/**
 *  返回状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)createButtonsBaseNavViewControllers
{
    UIButton *pushButton = [self buttonViewTitle:@"Push" selector:@"pushViewController:"];
    
    if (self.navigationController.navigationController.viewControllers.count > 1) {
        UIButton *popToButton = [self buttonViewTitle:@"PopTo" selector:@"popToViewController:"];
        UIButton *popToRootButton = [self buttonViewTitle:@"PopToRoot" selector:@"popToRootViewController:"];
        
        [popToButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20.0);
            make.right.equalTo(self.view).offset(-20.0);
            make.height.mas_equalTo(60.0);
            make.centerY.equalTo(self.view);
        }];
        
        [pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.height.equalTo(popToButton);
            make.bottom.equalTo(popToButton.mas_top).offset(-20.0);
        }];
        
        [popToRootButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.height.equalTo(popToButton);
            make.top.equalTo(popToButton.mas_bottom).offset(20.0);
        }];
    }
    else {
        [pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20.0);
            make.right.equalTo(self.view).offset(-20.0);
            make.height.mas_equalTo(60.0);
            make.centerY.equalTo(self.view);
        }];
    }
}

- (UIButton *)buttonViewTitle:(NSString *)title selector:(NSString *)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MXTRandomColor();
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

/**
 *  Push到下个界面
 */
- (void)pushViewController:(UIButton *)button
{
    PushViewController *pushViewController = [PushViewController new];
    [self.navigationController pushViewController:pushViewController animated:YES];
}

/**
 *  Pop到指定的界面
 */
- (void)popToViewController:(UIButton *)button
{
    for (MXContainerViewController *containerViewController in self.navigationController.navigationController.viewControllers) {
        UIViewController *viewController = containerViewController.viewController;
        if ([viewController isMemberOfClass:[MainViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

/**
 *  Pop到首界面
 */
- (void)popToRootViewController:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc.", [self.class description]);
}

@end
