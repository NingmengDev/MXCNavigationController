//
//  MXCNavigationController.m
//  MXCNavigationController
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXCNavigationController.h"

#import "MXCNavigationContainer.h"

@implementation MXCNavigationController

// Initialize and set the delegate to self.
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (void)setInteractivePopGestureRecognizerEnabled:(BOOL)interactivePopGestureRecognizerEnabled
{
    if ([self.navigationController respondsToSelector:@selector(containerPopGestureRecognizerEnabled)]) {
        [self.navigationController setValue:@(interactivePopGestureRecognizerEnabled) forKey:@"containerPopGestureRecognizerEnabled"];
    }
}

- (BOOL)interactivePopGestureRecognizerEnabled
{
    if ([self.navigationController respondsToSelector:@selector(containerPopGestureRecognizerEnabled)]) {
        return [[self.navigationController valueForKey:@"containerPopGestureRecognizerEnabled"] boolValue];
    }
    
    return NO;
}

// Handle back item click event.
- (void)leftBarButtonItemEvent:(UIBarButtonItem *)item
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Override Super Method

// Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    MXContainerViewController *containerViewController = [MXContainerViewController containerViewControllerWithViewController:viewController];
    
    if (self.navigationController.viewControllers.count) {
        if (!viewController.navigationItem.hidesBackButton) {
            UIImage *image = [UIImage imageNamed:@"mxc_nav_back_image.png"];
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemEvent:)];
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        /**
         *  Push的时候控制是否隐藏TabBar
         */
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [self.navigationController pushViewController:containerViewController animated:animated];
}

// Returns the popped controller.
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *containerViewController = [self.navigationController popViewControllerAnimated:animated];
    if ([containerViewController respondsToSelector:@selector(viewController)]) {
        containerViewController = [containerViewController valueForKey:@"viewController"];
    }
    return containerViewController;
}

// Pops view controllers until the one specified is on top. Returns the popped controllers.
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![viewController isMemberOfClass:[MXContainerViewController class]]) {
        viewController = viewController.navigationController.parentViewController;
    }
    
    NSArray *viewControllers = [self.navigationController popToViewController:viewController animated:animated];
    return [viewControllers valueForKeyPath:@"viewController"];
}

// Pops until there's only a single view controller left on the stack. Returns the popped controllers.
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray *viewControllers = [self.navigationController popToRootViewControllerAnimated:animated];
    return [viewControllers valueForKeyPath:@"viewController"];
}

#pragma mark - UINavigationControllerDelegate

/**
 *  导航栏将要显示某个viewController时调用
 *
 *  @param navigationController 导航栏
 *  @param viewController       将要显示的viewController
 *  @param animated             是否启用动画
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /* 在这里可以加上自己的处理代码 */
    // ......
}

/**
 *  导航栏完成显示某个viewController时调用
 *
 *  @param navigationController 导航栏
 *  @param viewController       将要显示的viewController
 *  @param animated             是否启用动画
 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /* 在这里可以加上自己的处理代码 */
    // ......
}

@end
