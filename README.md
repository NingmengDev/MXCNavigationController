# MXCNavigationController
自定义导航栏控制器，使各个viewController之间的导航栏不相互影响。

=================== 使用说明 ===================   

此导航栏在 https://github.com/JNTian/JTNavigationController.git 的基础上进行修改，仅作学习之用。    

此导航栏总体结构：   
 UIWindow    
    |    
 UINavigationController   //根导航栏（MXContainerNavigationController）   
    |    
 UIViewController         //导航栏容器（MXContainerViewController）   
    |    
 UINavigationController   //界面上看到view的导航栏（MXCNavigationController）   
    |    
 UIViewController         //界面上看到的view的viewController   
 
 使用规则：   
    1、需要加入导航栏控制器时，请使用[MXContainerNavigationController initWithRootViewController:]方法传入viewController；   
    2、需要Push的地方，使用方法与系统自带导航栏使用方法一致；   
    3、需要Pop的地方，popViewController和popToRoot使用方法与系统自带导航栏使用方法一致，popToViewController与系统自带导航栏使用方法有些差异，详见Demo;    
    4、界面上导航栏左右边按钮的自定义使用方法与系统使用方法一致；   
    5、导航栏默认开启全屏Pop手势，如需在某个viewController中禁用的话，设置MXCNavigationController的interactivePopGestureRecognizerEnabled属性为NO即可。

  已知问题：   
    此导航在与UITabBarController配合使用时，tabBarController中的viewController即使在没有显示出来时也会调用了viewDidLoad方法。
