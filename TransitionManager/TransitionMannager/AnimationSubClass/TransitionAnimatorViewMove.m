//
//  TransitionAnimatorViewMove.m
//  TransitionManager
//
//  Created by long on 2017/7/7.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimatorViewMove.h"

@implementation TransitionAnimatorViewMove

- (void)transitionAnimationWithIsBack:(BOOL)isBack
{
    if (!isBack) {
        [self transitionNextViewMoveAnimator];
    }else {
        [self transitionBackViewMoveAnimator];
    }
}

- (void)transitionNextViewMoveAnimator
{
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *tempView = [self.startView snapshotViewAfterScreenUpdates:NO];
    UIView *containerView = [self.transitionContext containerView];
    
    [containerView addSubview:toView];
    [containerView addSubview:tempView];
    
    tempView.frame = [fromView convertRect:self.startView.frame toView:containerView];
    toView.alpha = 0.0;
    fromView.alpha = 1.0;
    self.startView.hidden = YES;
    self.endView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    void(^AnimationBlock)() = ^() {
        tempView.frame = [toView convertRect:weakSelf.endView.frame toView:containerView];
        toView.alpha = 1.0;
        fromView.alpha = 0.0;
    };
    
    void(^AnimationCompletion)() = ^(void) {
        tempView.hidden = YES;
        weakSelf.startView.hidden = NO;
        weakSelf.endView.hidden = NO;
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    };
    
    
    if (self.viewMoveType == ViewMoveTypeViewSpringMove) {
        
        [UIView animateWithDuration:self.transitionProperty.animationTime delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1 / 0.7 options:0 animations:^{
            AnimationBlock();
        } completion:^(BOOL finished) {
            AnimationCompletion();
        }];
        
    }else {
        
        [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
            AnimationBlock();
        } completion:^(BOOL finished) {
            AnimationCompletion();
        }];
        
    }
}

- (void)transitionBackViewMoveAnimator
{
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [self.transitionContext containerView];
    UIView *tempView = containerView.subviews.lastObject;
    
    [containerView insertSubview:toView atIndex:0];
    
    tempView.frame = [self.endView convertRect:self.endView.bounds toView:fromView];
    tempView.hidden = NO;
    toView.alpha = 1;
    fromView.alpha = 1;
    self.endView.hidden = YES;
    self.startView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    __weak UIView *weakFromView = fromView;
    __weak UIView *weakToView = toView;
    __weak UIView *weakTempView = tempView;
    void(^AnimationBlock)() = ^(){
        weakTempView.frame = [weakSelf.startView convertRect:weakSelf.startView.bounds toView:containerView];
        weakToView.alpha = 1;
        weakFromView.alpha = 0;
    };
    
    void(^AnimationCompletion)() = ^(void) {
        if ([weakSelf.transitionContext transitionWasCancelled]) {
            weakTempView.hidden = YES;
            weakSelf.endView.hidden = NO;
            weakSelf.startView.hidden = NO;
            [weakSelf.transitionContext completeTransition:NO];
        }else{
            toView.hidden = NO;
            [weakTempView removeFromSuperview];
            weakSelf.startView.hidden = NO;
            weakSelf.endView.hidden = YES;
            [weakSelf.transitionContext completeTransition:YES];
        }
    };
    
    
    if (self.viewMoveType == ViewMoveTypeViewSpringMove) {
        
        [UIView animateWithDuration:self.transitionProperty.animationTime delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1 / 0.7 options:0 animations:^{
            AnimationBlock();
        } completion:^(BOOL finished) {
            AnimationCompletion();
        }];
        
    }else {
        
        [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
            AnimationBlock();
        } completion:^(BOOL finished) {
            AnimationCompletion();
        }];
        
    }
    
    self.interactiveBlock = ^(BOOL success) {
        
        if (success) {
            weakFromView.hidden = YES;
            [weakTempView removeFromSuperview];
            weakSelf.startView.hidden = NO;
            weakSelf.endView.hidden = YES;
        }
    };
}

@end

