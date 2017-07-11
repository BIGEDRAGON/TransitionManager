//
//  TransitionAnimatorRotationPresent.m
//  TransitionManager
//
//  Created by long on 2017/7/10.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimatorRotationPresent.h"

@implementation TransitionAnimatorRotationPresent

- (void)transitionAnimationWithIsBack:(BOOL)isBack
{
    if (!isBack) {
        [self transitionNextRotationPresentAnimator];
    }else {
        [self transitionBackRotationPresentAnimator];
    }
}

- (void)transitionNextRotationPresentAnimator
{
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *toSnapshotView = [toView snapshotViewAfterScreenUpdates:YES];
    UIView *containerView = [self.transitionContext containerView];
    
    toSnapshotView.layer.anchorPoint = CGPointMake(0.5, 2);
    toSnapshotView.frame = [UIScreen mainScreen].bounds;
    
    [containerView addSubview:toView];
    [containerView addSubview:toSnapshotView];
    [containerView insertSubview:toView atIndex:0];
    
    CGFloat angle = (self.direction == RotationPresentDirectionFromLeft) ? -M_PI_2 : M_PI_2;
    toSnapshotView.transform = CGAffineTransformMakeRotation(angle);
    
    [UIView animateWithDuration:self.transitionProperty.animationTime delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 / 0.7 options:0 animations:^{
        toView.alpha = 1.0;
        toSnapshotView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        if ([self.transitionContext transitionWasCancelled]) {
            [self.transitionContext completeTransition:NO];
        }else {
            toSnapshotView.hidden = YES;
            [self.transitionContext completeTransition:YES];
        }
    }];
}

- (void)transitionBackRotationPresentAnimator
{
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [self.transitionContext containerView];
    
    UIView *tempView = containerView.subviews[1];
    tempView.hidden = NO;
    [containerView addSubview:toView];
    [containerView insertSubview:toView belowSubview:tempView];
    
    
    [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
        CGFloat angle = (self.direction == RotationPresentDirectionFromLeft) ? -M_PI_2 : M_PI_2;
        if (tempView.transform.b > 0)
        {
            tempView.transform = CGAffineTransformMakeRotation(angle);
        } else
        {
            tempView.transform = CGAffineTransformMakeRotation(-angle);
        }
        
    } completion:^(BOOL finished) {
        if ([self.transitionContext transitionWasCancelled]) {
            [self.transitionContext completeTransition:NO];
        }else {
            [tempView removeFromSuperview];
            [self.transitionContext completeTransition:YES];
        }
    }];
    
    
    self.interactiveBlock = ^(BOOL success) {
        if (success) {
            [tempView removeFromSuperview];
            toView.hidden = NO;
        }else {
            tempView.hidden = YES;
            [toView removeFromSuperview];
        }
    };
}

@end
