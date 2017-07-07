//
//  TransitionAnimationTool+System.m
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+System.h"
#import "TransitionAnimator+SystemType.h"
#import <objc/runtime.h>

static NSString * const animationBlockKey = @"animationBlock";

@interface TransitionAnimator ()<CAAnimationDelegate>

@end

@implementation TransitionAnimator (System)

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        void(^animationBlock)() = objc_getAssociatedObject(self, &animationBlockKey);
        animationBlock ? animationBlock() : nil;
        animationBlock = nil;
    }
}

- (void)systemTransitionAnimatorWithIsBack:(BOOL)isBack
{
    UIView *toView              =   [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView       =   [self.transitionContext containerView];
    
    // 添加快照，以便实现动画
    UIView *toSnapshotView      =   [toView snapshotViewAfterScreenUpdates:YES];
    
    [containerView addSubview:toSnapshotView];
    
    CATransition *tranAnimation = isBack ? [self getSystemBackTransition] : [self getSystemTransition];
    tranAnimation.delegate = self;
    [containerView.layer addAnimation:tranAnimation forKey:nil];
    
    __weak TransitionAnimator *WeakSelf = self;
    
    objc_setAssociatedObject(self, &animationBlockKey, (^(){
        
        // 移除快照
        [toSnapshotView removeFromSuperview];
        
        if ([WeakSelf.transitionContext transitionWasCancelled]) {
            
            [WeakSelf.transitionContext completeTransition:NO];
        }else{
            
            [containerView addSubview:toView];
            
            // 设置transitionContext通知系统动画执行完毕
            [WeakSelf.transitionContext completeTransition:YES];
        }
    }), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

@end
