//
//  TransitionAnimator+ViewMode.m
//  TransitionManager
//
//  Created by long on 2017/6/30.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+ViewMove.h"

@implementation TransitionAnimator (ViewMove)

- (void)transitionAnimatorViewMoveWithIsBack:(BOOL)isBack
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
    UIView *tempView = [self.transitionProperty.startView snapshotViewAfterScreenUpdates:NO];
    UIView *containerView = [self.transitionContext containerView];
    
    [containerView addSubview:toView];
    [containerView addSubview:tempView];
    
    tempView.frame = [fromView convertRect:self.transitionProperty.startView.frame toView:containerView];
    toView.alpha = 0.0;
    fromView.alpha = 1.0;
    self.transitionProperty.startView.hidden = YES;
    self.transitionProperty.endView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    void(^AnimationBlock)() = ^() {
        tempView.frame = [toView convertRect:weakSelf.transitionProperty.endView.frame toView:containerView];
        toView.alpha = 1.0;
        fromView.alpha = 0.0;
    };
    
    void(^AnimationCompletion)() = ^(void) {
        tempView.hidden = YES;
        weakSelf.transitionProperty.startView.hidden = NO;
        weakSelf.transitionProperty.endView.hidden = NO;
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    };
    
    
    if (self.transitionProperty.animationType == TransitionAnimationTypeViewSpringMove) {
        
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
    
    tempView.frame = [self.transitionProperty.endView convertRect:self.transitionProperty.endView.bounds toView:fromView];
    tempView.hidden = NO;
    toView.alpha = 1;
    fromView.alpha = 1;
    self.transitionProperty.endView.hidden = YES;
    self.transitionProperty.startView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    __weak UIView *weakFromView = fromView;
    __weak UIView *weakToView = toView;
    __weak UIView *weakTempView = tempView;
    void(^AnimationBlock)() = ^(){
        weakTempView.frame = [weakSelf.transitionProperty.startView convertRect:weakSelf.transitionProperty.startView.bounds toView:containerView];
        weakToView.alpha = 1;
        weakFromView.alpha = 0;
    };
    
    void(^AnimationCompletion)() = ^(void) {
        if ([weakSelf.transitionContext transitionWasCancelled]) {
            weakTempView.hidden = YES;
            weakSelf.transitionProperty.endView.hidden = NO;
            weakSelf.transitionProperty.startView.hidden = NO;
            [weakSelf.transitionContext completeTransition:NO];
        }else{
            toView.hidden = NO;
            [weakTempView removeFromSuperview];
            weakSelf.transitionProperty.startView.hidden = NO;
            weakSelf.transitionProperty.endView.hidden = YES;
            [weakSelf.transitionContext completeTransition:YES];
        }
    };
    
    
    if (self.transitionProperty.animationType == TransitionAnimationTypeViewSpringMove) {
        
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
            weakSelf.transitionProperty.startView.hidden = NO;
            weakSelf.transitionProperty.endView.hidden = YES;
        }
    };
}

@end
