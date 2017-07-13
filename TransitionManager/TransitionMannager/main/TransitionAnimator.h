//
//  TransitionAnimationTool.h
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionProperty.h"

@interface TransitionAnimator : NSObject
<UIViewControllerAnimatedTransitioning,
CAAnimationDelegate>

@property (nonatomic, strong) TransitionProperty *transitionProperty;

// 普通转场动画执行结束Block
@property (nonatomic, copy) void(^animationBlock)();
// 交互式动画执行结束Block
// success：是否成功
@property (nonatomic, copy) void(^interactiveBlock)(BOOL success);


@property (nonatomic, assign) id <UIViewControllerContextTransitioning> transitionContext;



/**
 take attention :
 
 当需要添加新的属性才能完成动画时，如：ViewMove需要知道startView和endView
 此时 1.可以创建一个TransitionAnimator的subClass，需重写本方法
     2.调用push或者present时，需创建并设置property的customAnimator对象

 @param isBack 是否是pop还是dismiss
 */
- (void)transitionAnimationWithIsBack:(BOOL)isBack;

@end
