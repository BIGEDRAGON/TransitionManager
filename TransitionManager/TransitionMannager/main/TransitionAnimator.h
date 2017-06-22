//
//  TransitionAnimationTool.h
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionProperty.h"

@interface TransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) TransitionProperty *transitionProperty;

// 普通转场动画执行结束Block
@property (nonatomic, copy) void(^animationBlock)();
// 交互式动画执行结束Block
// success：是否成功
@property (nonatomic, copy) void(^interactiveBlock)(BOOL success);


@property (nonatomic, assign) id <UIViewControllerContextTransitioning> transitionContext;

@end
