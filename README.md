## 介绍篇

### 写在前面
iOS 7 SDK之前的VC切换方式举例：

```
__weak id weakSelf = self;
[self transitionFromViewController:fromVC
                  toViewController:toVC 
                  duration:0.3 
                  options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{}
                  completion:^(BOOL finished) {
                        
}];
```

iOS 7 自定义ViewController动画切换有以下几种方式：

1. `UITabBarController` 中切换Tab（可仿安卓手动滑动切换 `tabbar` ）
2. `UINavigationController` 的 `push` 和`pop`  切换
3. 当控制器的 `modalPresentationStyle` 属性为 `UIModalPresentationFullScreen` 或 `UIModalPresentationCustom` 这两种模式时，可进行`Modal` 转场：`presentation` 和 `dismissal`

之前在网上看了很多自定义转场相关的blog和demo，网上在这方面已流传甚广，我记录下这个简易博文，是提示封装能力、加深印象和回顾使用之用，如有问题可以@我，目前只**封装了上述转场类型的第2和第3点（全都支持交互式动画、既手势动画）** [demo在此 0.0](https://git.oschina.net/LongLJ/transitionmanager.git)

### 各位大哥，效果图献上（全部可设置手势）：

1. 系统动画系列（`Modal` 转场版）
	
	![](https://git.oschina.net/uploads/images/2017/0706/114032_2ede1385_657827.gif "system")
	
2. 类似KeyNote的局部控件move动画

	![](https://git.oschina.net/uploads/images/2017/0706/134824_9e3690f8_657827.gif "ViewMove")
	
3. 翻页效果

	![](https://git.oschina.net/uploads/images/2017/0706/114113_85602f8a_657827.gif "Page")
	
4. 普通开关门效果

        ![输入图片说明](https://git.oschina.net/uploads/images/2017/0706/135050_ded83643_657827.gif "在这里输入图片标题")
	
5. 立体开关门效果

        ![](https://git.oschina.net/uploads/images/2017/0706/135111_0bf7a32e_657827.gif "在这里输入图片标题")


## 原理篇

### 概括流程

- 针对不同的转场方式，不同的对象遵循不同的代理

	```
	1. UITabBarController 遵循 <UITabBarControllerDelegate>
	2. Push 和 Pop 遵循 <UINavigationControllerDelegate>
	3. Present 和 Dismiss 遵循 <UIViewControllerTransitioningDelegate>
	```
- 实现对应的代理方法（后面对应细讲）
	> interactive代理 --> 返回交互式对象，以为支持手势返回，所以存在后面需要创建这对象 
	
	> animation代理 --> 返回动画对象
	
	- UITabBarController
		
		```
		// interactive代理
		- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController NS_AVAILABLE_IOS(7_0);
		// animation代理
		- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);
		```		
	- Push 和 Pop

		```
		// interactive代理
		- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
	                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);
	
		// animation代理
		- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
	                                   animationControllerForOperation:(UINavigationControllerOperation)operation
	                                                fromViewController:(UIViewController *)fromVC
	                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);
		```
	- Present 和 Dismiss

		```
		// interactive代理
		- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

		// animation代理
		- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
	                                                  presentingController:(UIViewController *)presenting
	                                                  sourceController:(UIViewController *)source;

		// interactive代理
		- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

		// animation代理
		- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
		```
	
- 创建动画对象类，遵循`<UIViewControllerAnimatedTransitioning>`
协议，实现其代理

	```
	@required
	// 动画时间
	- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
	// 执行动画
	- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

	@optional
	// 动画结束
	- (id <UIViewImplicitlyAnimating>) interruptibleAnimatorForTransition:(id <UIViewControllerContextTransitioning>)transitionContext NS_AVAILABLE_IOS(10_0);
	```
	- **PS:** 遵守 `<UIViewControllerContextTransitioning>` 的对象 `transitionContext` ，它有以下几个方法来提供动画控制器需要的信息：
	
		```
		// 返回容器视图，转场动画发生的地方。
		- (UIView *)containerView;
		// 获取参与转场的视图控制器，有 UITransitionContextFromViewControllerKey 和 UITransitionContextToViewControllerKey 两个 Key.
		- (nullable __kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key;
		// iOS 8新增 API 用于方便获取参与参与转场的视图，有 UITransitionContextFromViewKey 和 UITransitionContextToViewKey 两个 Key。
		- (nullable __kindof UIView *)viewForKey:(UITransitionContextViewKey)key;
		```
- 创建交互式对象类，继承 UIPercentDrivenInteractiveTransition（遵循`<UIViewControllerInteractiveTransitioning>`协议）
	- 通过类方法创建PercentInteractive对象，且根据传入的animator设置相关可用属性、给传入的vc创建一个UIPanGestureRecognizer手势
	- 根据手势状态做不同操作：
		- began：设置动画标识isInteractive为YES，进行pop或者dismiss操作
		- changed：调用updateInteractiveTransition刷新动画
		- ended&cancelled：设置动画标识isInteractive为NO，给个CADisplayLink刷新动画，直至finishInteractiveTransition或者cancelInteractiveTransition动画



## TransitionManager代码篇

因为时间关系、只用xmind画好了逻辑架构图、文章介绍目前还没有写，后续补上。。。

### UITabBarController（未包含）

略 -。- 


### Push 和 Pop

待补上。。。


### Present 和 Dismiss

待补上。。。