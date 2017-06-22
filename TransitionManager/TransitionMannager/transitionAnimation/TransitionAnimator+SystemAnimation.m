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
    
    __weak TransitionAnimator *WeakSelf = self;
    self.animationBlock = ^(){
        
//        if ([WeakSelf.transitionContext transitionWasCancelled]) {
//            [WeakSelf.transitionContext completeTransition:NO];
//            
////            toVC.view.hidden = YES;
//        }else{
//            [WeakSelf.transitionContext completeTransition:YES];
//            
//            [containerView addSubview:toVC.view];
//        }
        
        // 移除快照，这边没有将快照添加到containerView，所以不需要移除
        [fromSnapshotView removeFromSuperview];
        [toSnapshotView removeFromSuperview];
        
        
        // 设置transitionContext通知系统动画执行完毕
        [[WeakSelf.transitionContext containerView]addSubview:toView];
        [WeakSelf.transitionContext completeTransition:![WeakSelf.transitionContext transitionWasCancelled]];
    };
    
    if (isBack) {
        self.interactiveBlock = ^(BOOL success){
            
            if (success) {
                [containerView addSubview:toView];
            }
            
            // 移除快照，这边没有将快照添加到containerView，所以不需要移除
            [fromSnapshotView removeFromSuperview];
            [toSnapshotView removeFromSuperview];
        };
    }
}

@end
