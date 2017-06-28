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

- (void)systemTransitionAnimatorWithIsBack:(BOOL)isBack
{
    UIView *toView              =   [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView       =   [self.transitionContext containerView];
    
    // 添加快照，以便实现动画
    UIView *toSnapshotView      =   [toView snapshotViewAfterScreenUpdates:YES];
    
    [containerView addSubview:toSnapshotView];
    
    CATransition *tranAnimation = isBack ? [self getSystemBackTransition] : [self getSystemTransition];
    [containerView.layer addAnimation:tranAnimation forKey:nil];
    
    __weak TransitionAnimator *WeakSelf = self;
    self.animationBlock = ^(){
        
        // 移除快照
        [toSnapshotView removeFromSuperview];
        
        if ([WeakSelf.transitionContext transitionWasCancelled]) {
            
            [WeakSelf.transitionContext completeTransition:NO];
        }else{
            
            [containerView addSubview:toView];
            
            // 设置transitionContext通知系统动画执行完毕
            [WeakSelf.transitionContext completeTransition:YES];
        }
    };
}

@end
