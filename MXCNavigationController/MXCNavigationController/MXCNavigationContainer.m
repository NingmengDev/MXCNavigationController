//
//  MXCNavigationContainer.m
//  MXCNavigationController
//
//  Created by 韦纯航 on 16/4/30.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXCNavigationContainer.h"

#import "MXCNavigationController.h"

#pragma mark - MXTContainerViewController

@implementation MXContainerViewController

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController
{
    MXCNavigationController *navigationController = [MXCNavigationController new];
    navigationController.viewControllers = @[viewController];
    
    MXContainerViewController *containerViewController = [MXContainerViewController new];
    [containerViewController.view addSubview:navigationController.view];
    [containerViewController addChildViewController:navigationController];
    return containerViewController;
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

#pragma mark - Override Super Method

- (nullable UIViewController *)childViewControllerForStatusBarStyle
{
    return [self viewController];
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden
{
    return [self viewController];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return [self viewController].hidesBottomBarWhenPushed;
}

/**
 *  返回初始化时传入的viewController
 */
- (UIViewController *)viewController
{
    UINavigationController *navigationController = self.childViewControllers.firstObject;
    return navigationController.viewControllers.firstObject;
}

@end


@interface MXContainerNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

/**
 *  全屏Pop手势
 */
@property (strong, nonatomic) UIPanGestureRecognizer *popGestureRecognizer;

@end

@implementation MXContainerNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        MXContainerViewController *containerViewController = [MXContainerViewController containerViewControllerWithViewController:rootViewController];
        self.viewControllers = @[containerViewController];
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBarHidden:YES];
    [self configureCommonAttributes];
    [self replaceInteractivePopGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  配置导航栏上的Item的默认属性
 */
- (void)configureCommonAttributes
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

/**
 *  替换掉系统的右滑返回手势
 */
- (void)replaceInteractivePopGestureRecognizer
{
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    id popGestureRecognizerTarget = self.interactivePopGestureRecognizer.delegate;
    SEL popGestureRecognizerAction = NSSelectorFromString(@"handleNavigationTransition:");
    
    UIPanGestureRecognizer *popGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    popGestureRecognizer.delegate = self;
    popGestureRecognizer.maximumNumberOfTouches = 1;
    popGestureRecognizer.enabled = NO;
    [popGestureRecognizer addTarget:popGestureRecognizerTarget action:popGestureRecognizerAction];
    [targetView addGestureRecognizer:popGestureRecognizer];
    [self setPopGestureRecognizer:popGestureRecognizer];
    
    /**
     *  全屏Pop手势默认启用
     */
    self.containerPopGestureRecognizerEnabled = YES;
    
    /**
     *  将系统自带的导航栏返回手势禁用掉
     */
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)setContainerPopGestureRecognizerEnabled:(BOOL)containerPopGestureRecognizerEnabled
{
    BOOL isRootViewController = (self.viewControllers.count == 1);
    self.popGestureRecognizer.enabled = (!isRootViewController && containerPopGestureRecognizerEnabled);
    
    _containerPopGestureRecognizerEnabled = containerPopGestureRecognizerEnabled;
}

#pragma mark - UIGestureRecognizerDelegate

/**
 *  此代理方法为处理全屏Pop手势是否可用的首调方法
 *  在此方法中可以根据touch中的view类型来设置手势是否可用
 *  比如：界面中触摸到了按钮，则禁止使用手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    
    UIView *touchView = [touch view];
    if ([touchView isMemberOfClass:[UIButton class]] ||
        [touchView isKindOfClass:[UINavigationBar class]])
    {
        return NO;
    }
    
    return self.containerPopGestureRecognizerEnabled;
}

/**
 *  当方法gestureRecognizer:shouldReceiveTouch:返回的值为NO，此方法将不再被调用
 *  当此方法被调用时，全屏Pop手势是否可用要根据四个情况来确定
 *
 *  第一种情况：当前控制器为根控制器了，全屏Pop手势手势不可用
 *  第二种情况：如果导航栏Push、Pop动画正在执行（私有属性）时，全屏Pop手势不可用
 *  第三种情况：手势是上下移动方向，全屏Pop手势不可用
 *  第四种情况：手势是右往左移动方向，全屏Pop手势不可用
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint vTranslationPoint = [recognizer translationInView:recognizer.view];
    if (fabs(vTranslationPoint.x) > fabs(vTranslationPoint.y)) { //左右滑动
        BOOL isRootViewController = (self.viewControllers.count == 1);
        BOOL isTransitioning = [[self valueForKey:@"_isTransitioning"] boolValue];
        BOOL isPanPortraitToLeft = (vTranslationPoint.x < 0);
        return !isRootViewController && !isTransitioning && !isPanPortraitToLeft;
    }
    
    return NO;
}

#pragma mark - UINavigationControllerDelegate

/**
 *  导航栏完成显示某个viewController时调用
 *
 *  @param navigationController 导航栏
 *  @param viewController       将要显示的viewController
 *  @param animated             是否启用动画
 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /**
     *  解决回到导航栏根控制器时，触发Pop手势后，再执行Push时会出现卡死的情况
     */
    BOOL isRootViewController = (viewController == navigationController.viewControllers.firstObject);
    self.popGestureRecognizer.enabled = (!isRootViewController && self.containerPopGestureRecognizerEnabled);
}

@end
