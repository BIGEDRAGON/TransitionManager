//
//  TransitionAnimation+PageAnimation.h
//  TransitionManager
//
//  Created by long on 2017/6/16.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator.h"

@interface TransitionAnimator (PageAnimation)

- (void)transitionNextPageAnimatorWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)transitionBackPageAnimatorWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
