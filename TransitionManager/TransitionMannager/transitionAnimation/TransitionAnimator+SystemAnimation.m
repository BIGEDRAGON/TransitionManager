//
//  TransitionAnimationTool+System.m
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+SystemAnimation.h"
#import "TransitionAnimator+SystemType.h"


@implementation TransitionAnimator (SystemAnimation)

- (void)transitionSystemAnimatorWithIsBack:(BOOL)isBack
{
    UIView *fromView            =   [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView              =   [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView       =   [self.transitionContext containerView];
    
    // 添加快照，以便实现动画
    UIView *fromSnapshotView    =   [fromView snapshotViewAfterScreenUpdates:YES];
    UIView *toSnapshotView      =   [toView snapshotViewAfterScreenUpdates:YES];
    
    [containerView addSubview:fromSnapshotView];
    [containerView addSubview:toSnapshotView];
    
    CATransition *tranAnimation = isBack ? [self getSystemBackTransition] : [self getSystemTransition];
    [containerView.layer addAnimation:tranAnimation forKey:nil];
    
    __block BOOL interactiveSuccess = YES;
    __weak TransitionAnimator *WeakSelf = self;
    self.animationBlock = ^(){
        
        if (!interactiveSuccess) {
            [WeakSelf.transitionContext completeTransition:![WeakSelf.transitionContext transitionWasCancelled]];
            return;
        }
        
        // 移除快照
        [fromSnapshotView removeFromSuperview];
        [toSnapshotView removeFromSuperview];
        
        
        // 设置transitionContext通知系统动画执行完毕
        [containerView addSubview:toView];
        [WeakSelf.transitionContext completeTransition:![WeakSelf.transitionContext transitionWasCancelled]];
    };
    
    self.interactiveBlock = ^(BOOL success){
        interactiveSuccess = success;
        if (success) {
            [containerView addSubview:toView];
        }
        
        // 移除快照
        [fromSnapshotView removeFromSuperview];
        [toSnapshotView removeFromSuperview];
    };
}

@end
