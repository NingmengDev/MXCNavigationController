//
//  MXCNavigationContainer.h
//  MXCNavigationController
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  MXCNavigationController的容器，在界面上看不到
 */
@interface MXContainerViewController : UIViewController

/**
 *  返回初始化时传入的viewController
 */
@property (readonly) UIViewController *viewController;

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController;

@end


/**
 *  根导航栏控制器，在界面上看不到，全局控制界面的Push和Pop
 */
@interface MXContainerNavigationController : UINavigationController

/**
 *  全屏Pop手势是否可用
 */
@property (assign, nonatomic) BOOL containerPopGestureRecognizerEnabled;

@end
