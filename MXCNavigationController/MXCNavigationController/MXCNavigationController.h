//
//  MXCNavigationController.h
//  MXCNavigationController
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  界面上看到的真正的导航栏
 *  在viewController中通过self.navigationController获取到的均是MXCNavigationController
 *  在viewController中可通过self.navigationController.navigationController获取到看不见的根导航栏MXContainerNavigationController
 */
@interface MXCNavigationController : UINavigationController <UINavigationControllerDelegate>

/**
 *  全屏Pop手势是否可用
 */
@property (readwrite) BOOL interactivePopGestureRecognizerEnabled;

@end
