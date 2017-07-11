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

之前在网上看了很多自定义转场相关的blog和demo，网上在这方面已流传甚广，我记录下这个简易博文，是提示封装能力、加深印象和回顾使用之用，如有问题可以@我，目前只**封装了上述转场类型的第2和第3点（全都支持交互式动画、既手势动画）** [demo在此 0.0](https://github.com/BIGEDRAGON/TransitionManager.git)。

如果之前对自定义转场动画没有接触过的guys，下面的原理篇可以粗略看一番先~~ 

本项目使用颇为简单，扩展也很方便，具体使用请看 `TransitionManager代码篇` 里面的《使用方法》

### 各位大哥，效果图先献上（全部可设置手势）：

1. 系统动画系列（`Modal` 转场版，category扩展）
	
	![](https://git.oschina.net/uploads/images/2017/0706/114032_2ede1385_657827.gif "system")
	
2. 类似KeyNote的局部控件move动画（subClass扩展）

	![](https://git.oschina.net/uploads/images/2017/0706/134824_9e3690f8_657827.gif "ViewMove")
	
3. 翻页效果（category扩展）

	![](https://git.oschina.net/uploads/images/2017/0706/114113_85602f8a_657827.gif "Page")
	
4. 普通开关门效果（category扩展）

	![](https://git.oschina.net/uploads/images/2017/0706/135050_ded83643_657827.gif "NormalPortal")
	
5. 立体开关门效果（category扩展）

	![](https://git.oschina.net/uploads/images/2017/0706/135111_0bf7a32e_657827.gif "SolidPortal")
	
6. 旋转弹出（category扩展）

	![](https://git.oschina.net/uploads/images/2017/0711/164848_0748ca93_657827.gif "RotationPresent")
	
7. 正在补充中 0_0


## 原理篇

> 因为本项目对系统的自定义转场动画进行了较多的封装，所以在介绍之前先讲讲系统自定义动画的原理

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
协议，实现其代理方法

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

经过上面的原理篇，相比对系统的自定义转场动画的一个流程已经相对比较熟悉了，接下来看我们的项目里面的代码实现。

我还用xmind画好了逻辑架构图、详见项目目录下的TransitionManager.xmind文件。
[Xmind软件下载地址（密码：c6cu）](https://pan.baidu.com/s/1eSDx9cA)

### 项目基本架构

#### 使用方法

```
// push
[self.navigationController lj_pushViewController:vc transition:^(TransitionProperty *property) {
	property.animationType = TransitionAnimationTypeSysCubeFromLeft;
	property.backGestureType = BackGestureTypeLeft | BackGestureTypeRight;
}];
// present
[self.navigationController lj_presentViewController:vc transition:^(TransitionProperty *property) {
	property.animationType = TransitionAnimationTypeSysCubeFromLeft;
	property.backGestureType = BackGestureTypeDown;
} completion:^{
	self.title = @"present后变化标题";
}];
```


1.给UINavigationController增加分类，提供其push方法

```
- (void)lj_pushViewController:(UIViewController *)viewController animationType:(TransitionAnimationType)animationType;
- (void)lj_pushViewController:(UIViewController *)viewController transition:(TransitionBlock)transitionBlock;
```
再用OC的runtime黑科技拦截pop方法进行处理,实现系统方法就可以有动画

2.给UIViewController增加分类，提供其Present方法

```
- (void)lj_presentViewController:(UIViewController *)viewController animationType:(TransitionAnimationType)animationType completion:(void (^)(void))completion;
- (void)lj_presentViewController:(UIViewController *)viewController transition:(TransitionBlock)transitionBlock completion:(void (^)(void))completion;
```
再用OC的runtime黑科技拦截dismiss方法进行处理,实现系统方法就可以有动画

**PS:**
> 1.还有 viewDidAppear 和 viewWillDisappear 方法也进行了runtime的 `Swizzle Method` ，两个分类的 `Swizzle Method` 后面CustomDelegate会讲述做了什么操作，见后面~~

> 2：上面的方法TransitionBlock闭包会提供一个对象 `TransitionProperty *property` ，该对象里面有变量（设置动画相关属性）如下：

```
/**
 * 转场动画时间，默认0.5s
 */
@property (nonatomic, assign) NSTimeInterval animationTime;

/**
 * 转场方式 ：push,pop,present,dismiss
 * 局限性、作为标识使用
 */
@property (nonatomic, assign) TransitionType transitionType;

/**
 * 转场动画类型
 */
@property (nonatomic, assign) TransitionAnimationType animationType;

/**
 * 返回的转场动画类型
 * 只在system中才可使用
 */
@property (nonatomic, assign) TransitionAnimationType backAnimationType;

/**
 * 是否采用系统原生返回方式，默认为NO
 * backGestureType为BackGestureTypeNone，该字段无效
 */
@property (nonatomic, assign) BOOL isSystemBackAnimation;

/**
 * 返回上个界面的手势 默认：右滑BackGestureTypeRight
 * 当为BackGestureTypeNone时，手势返回无效
 * isSystemBackAnimation为YES，该字段无效，默认：右滑BackGestureTypeRight
 */
@property (nonatomic, assign) BackGestureType backGestureType;

/**
 * 在动画之前隐藏NavigationBar,动画结束后显示,默认为NO
 */
@property (nonatomic, assign) BOOL autoShowAndHideNavBar;

/**
 * 显示隐藏NavigationBar的动画时间，默认0.25s
 */
@property (nonatomic, assign) NSTimeInterval showAndHideNavBarTime;

/**
 * 交互式动画的均值，超过就执行动画。默认0.3
 * 均值 = 偏移量 / view宽或高
 */
@property (nonatomic, assign) CGFloat interactivePercent;


/**
 设置TransitionAnimator的subClass，实现该subClass里面的动画
 ps：此时 animationType 设置无效
 */
@property (nonatomic, strong) TransitionAnimator *customAnimator;
```

#### CustomDelegate

遵循协议 `<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>` ，实现其代理方法，详见上面原理篇的第二点。

在这个类里面会对上面分类传过来的TransitionBlock闭包进行设置得到TransitionProperty对象，并设置CustomDelegate对象的变量

```
TransitionProperty *property = [[TransitionProperty alloc] init];
// 根据闭包设置property对象
if (self.transitionBlcok) {
    self.transitionBlcok(property);
}
self.backGestureEnable = property.backGestureType ? NO : YES;
self.isCustomBackAnimation = !property.isSystemBackAnimation;
    
property.transitionType = transitionType;
```
获取到的CustomDelegate对象的变量会在上面分类中使用，`backGestureEnable` 用来设置是否开始支持手势返回；`isCustomBackAnimation` 用来设置pop和dismiss是否也使用转场动画（既是否设置其对应代理）。

```
- (void)lj_viewDidAppear:(BOOL)animated {
    [self lj_viewDidAppear:animated];
    
    CustomDelegate *customDelegate = objc_getAssociatedObject(self, &customDelegateKey);
    if (customDelegate.backGestureEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)lj_viewWillDisappear:(BOOL)animated {
    [self lj_viewWillDisappear:animated];
    
    CustomDelegate *customDelegate = objc_getAssociatedObject(self, &customDelegateKey);
    if (customDelegate.backGestureEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
```

```
- (UIViewController *)lj_popViewControllerAnimated:(BOOL)animated
{
    CustomDelegate *customDelegate = objc_getAssociatedObject(self.viewControllers.lastObject, &customDelegateKey);
    if (customDelegate.isCustomBackAnimation) {
        self.delegate = customDelegate;
    }
    return [self lj_popViewControllerAnimated:animated];
}
- (void)lj_dismissViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    CustomDelegate *customDelegate = objc_getAssociatedObject(self, &customDelegateKey);
    if (customDelegate.isCustomBackAnimation) {
        self.transitioningDelegate = customDelegate;
    }
    [self lj_dismissViewControllerAnimated:animated completion:completion];
}
```

这个类也会创建相关的animator动画对象和interactive交互式对象

```
// 创建animator动画对象并赋值
if (!_animator) {
        property.customAnimator ? (_animator = property.customAnimator) : (_animator = [[TransitionAnimator alloc] init]);
    }
_animator.transitionProperty = property;
```
```
// 创建interactive交互式对象，类方法具体逻辑见下面 PercentInteractive 介绍
- (void)setPercentInteractiveWithVC:(UIViewController *)vc
{
    __weak CustomDelegate *WeakSelf = self;
    self.tempBlock = ^{
        if (_isCustomBackAnimation && _animator.transitionProperty.backGestureType != BackGestureTypeNone) {
            !WeakSelf.interactive ? WeakSelf.interactive = [PercentInteractive interactiveWithVC:vc animator:WeakSelf.animator] : nil;
        }
    };
}
```

#### TransitionAnimator

遵循转场动画协议 `<UIViewControllerAnimatedTransitioning>`，并实现其代理方法，详见上面原理篇的第三点

提供了两种扩展自定义动画的方法，详细操作后续分别会讲解 `category扩展自定义动画` 和 `subClass扩展自定义动画`，前者的处理方法代码如下：

```
// 执行自定义动画方法
unsigned int count = 0;
NSString *rangeStr = @"customTransitionAnimator";
Method *methodlist = class_copyMethodList([TransitionAnimator class], &count);
    
int tag = 0;
for (int i = 0; i < count; i++) {
    
    Method method = methodlist[i];
    SEL selector = method_getName(method);
    NSString *methodName = NSStringFromSelector(selector);
    
    if ([methodName rangeOfString:rangeStr].location != NSNotFound) {
        tag++;
        NSLog(@"第%d个customMethod ： %@", i, methodName);
        
        if (tag == _transitionProperty.animationType-TransitionAnimationTypeDefault) {
            
            // 发送消息，即调用对应的方法，这边必须实现，一一对应
            ((void (*)(id,SEL))objc_msgSend)(self,selector);
            break;
        }
    }
}
free(methodlist);
```

**PS:** 遵守 `<UIViewControllerContextTransitioning>` 协议的属性 `transitionContext` ，它有以下几个方法来提供动画控制器需要的信息：
	
```
// 返回容器视图，转场动画发生的地方。
- (UIView *)containerView;
// 获取参与转场的视图控制器，有 UITransitionContextFromViewControllerKey 和 UITransitionContextToViewControllerKey 两个 Key.
- (nullable __kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key;
// iOS 8新增 API 用于方便获取参与参与转场的视图，有 UITransitionContextFromViewKey 和 UITransitionContextToViewKey 两个 Key。
- (nullable __kindof UIView *)viewForKey:(UITransitionContextViewKey)key;
```

#### PercentInteractive

继承自 `UIPercentDrivenInteractiveTransition`，该类遵循协议 `<UIViewControllerInteractiveTransitioning>`

1. 上面CustomDelegate讲述的通过 PercentInteractive 类方法创建该对象，实现通过根据传入的animator设置相关可用属性、给传入的vc创建一个UIPanGestureRecognizer手势

	```
	UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:interactive action:@selector(panGesture:)];
    [interactiveVC.view addGestureRecognizer:ges];
    interactive.interActiveVC = interactiveVC;
    
    // 设置属性
    interactive.transitionType = animator.transitionProperty.transitionType;
    interactive.backGestureType = animator.transitionProperty.backGestureType;
    interactive.interActivePercent = animator.transitionProperty.interactivePercent;
    interactive.interactiveBlock = ^(BOOL suceess) {
        animator.interactiveBlock ? animator.interactiveBlock(suceess) : nil;
    };
	```

2.根据手势状态做不同操作：

- began：设置动画标识isInteractive为YES，进行pop或者dismiss操作
- changed：调用updateInteractiveTransition刷新动画
- ended&cancelled：设置动画标识isInteractive为NO，给个CADisplayLink刷新动画，直至finishInteractiveTransition或者cancelInteractiveTransition动画

	```
	switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_percent >= 0) {
                _isInteractive = YES;
                [self beganGesture];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_isInteractive) {
                [self updateInteractiveTransition:_percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (_isInteractive) {
                _isInteractive = NO;
                [self continueAction];
            }
        }
            break;
        default:
            break;
    }
    
    - (void)continueAction
	{
	    if (_displayLink) {
	        return;
	    }
	    
	    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(UIChange)];
	    [_displayLink  addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	}
	
	- (void)UIChange
	{
	    CGFloat timeDistance = 2.0/60;
	    if (_percent > _interActivePercent) {
	        _percent += timeDistance;
	    }else {
	        _percent -= timeDistance;
	    }
	    [self updateInteractiveTransition:_percent];
	    
	    if (_percent >= 1.0) {
	        _interactiveBlock ? _interactiveBlock(YES) : nil;
	        [self finishInteractiveTransition];
	        
	        [_displayLink invalidate];
	        _displayLink = nil;
	    }
	    
	    if (_percent <= 0.0) {
	        _interactiveBlock ? _interactiveBlock(NO) : nil;
	        [self cancelInteractiveTransition];
	        
	        [_displayLink invalidate];
	        _displayLink = nil;
	    }
	}
	```
	**PS:** 上面代码中的 `isInteractive` 和 `interactiveBlock 闭包`都是本类提供的属性，方便animator扩展自定义动画的时候使用，使其支持手势交互


### category扩展自定义动画

#### 适用情况

- TransitionAnimator 提供的属性够用
- 方便别人调用，只需在调用 push 或者 present 方法时，设置 property 的 animationType 属性即可（目前支持的 animationType 情况可查看 TypeDefConfig.h 配置文件）

#### 具体操作

1. 在 TypeDefConfig.h 配置文件的 TransitionAnimationType 枚举中增加动画类型
2. 创建 TransitionAnimator 的分类，提供公开的动画执行方法
3. 在 TransitionAnimator 类后面添加对象方法(方法名必须包含`customTransitionAnimator`字段)，里面实现第二步分类提供的动画执行方法
4. 在调用 push 或者 present 方法时，设置 property 的 animationType 属性值


### subClass扩展自定义动画

#### 适用情况

- TransitionAnimator 提供的属性不够用时使用，如：ViewMove 自定义动画需要知道 startView 和 endView 来实现动画
- 不想更改本项目内容，或想少写点东西都可使用 =.=

#### 具体操作

1. 创建 TransitionAnimator 的子类，重写其 `- (void)transitionAnimationWithIsBack:(BOOL)isBack` 方法
2. 调用 push 或者 present 方法时，需创建并设置 property 的 customAnimator 对象，此时 animationType 属性设置无效

```
// push
[self.navigationController lj_pushViewController:vc transition:^(TransitionProperty *property) {
	property.animationTime = 0.5;
	property.backGestureType = BackGestureTypeLeft | BackGestureTypeRight;
    // 设置了customAnimator，此时animationType设置无效
//  	property.animationType = TransitionAnimationTypeDefault;

	TransitionAnimatorViewMove *viewmove = [[TransitionAnimatorViewMove alloc] init];
	viewmove.startView = tap.view;
	viewmove.endView = weakVC.imageV;
	property.customAnimator = viewmove;
}];

// present
[self.navigationController lj_presentViewController:vc transition:^(TransitionProperty *property) {
    property.animationTime = 0.5;
    property.backGestureType = BackGestureTypeDown;
    
    TransitionAnimatorViewMove *viewmove = [[TransitionAnimatorViewMove alloc] init];
    viewmove.startView = tap.view;
    viewmove.endView = weakVC.imageV;
    property.customAnimator = viewmove;
} completion:nil];
```
