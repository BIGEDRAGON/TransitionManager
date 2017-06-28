//
//  TransitionAnimationTool.m
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "TransitionAnimator.h"
#import "TransitionAnimator+SystemAnimation.h"
#import "TransitionAnimator+PageAnimation.h"

@interface TransitionAnimator ()<CAAnimationDelegate>
{
    BOOL isBack;
}
@end

@implementation TransitionAnimator

#pragma mark - <UIViewControllerAnimatedTransitioning>
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _transitionProperty.animationTime;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 在动画之前隐藏NavigationBar
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC.navigationController.navigationBar && _transitionProperty.autoShowAndHideNavBar) {
        [UIView animateWithDuration:_transitionProperty.showAndHideNavBarTime animations:^{
            fromVC.navigationController.navigationBar.alpha = 0.0;
        }];
    }
    
    // 统一处理Default动画
    if (_transitionProperty.animationType == TransitionAnimationTypeDefault) {
        _transitionProperty.animationType = TransitionAnimationTypeSysPushFromLeft;
    }
    
    // 执行动画
    _transitionContext = transitionContext;
    
    switch (_transitionProperty.transitionType) {
        case TransitionTypePop:
        case TransitionTypeDismiss:
            isBack = YES;
            break;
        default:
            isBack = NO;
            break;
    }
    
    [self transitionAnimation];
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // 移除代理
    if (transitionCompleted) {
        
        UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        
        // 在动画结束后显示NavigationBar
        if (toVC.navigationController.navigationBar && _transitionProperty.autoShowAndHideNavBar) {
            [UIView animateWithDuration:_transitionProperty.showAndHideNavBarTime animations:^{
                toVC.navigationController.navigationBar.alpha = 1.0;
            }];
        }
        
        void (^removeDelegateBlock)() = ^() {
            fromVC.transitioningDelegate = nil;
            fromVC.navigationController.delegate = nil;
            toVC.transitioningDelegate = nil;
            toVC.navigationController.delegate = nil;
        };
        
        switch (_transitionProperty.transitionType) {
            case TransitionTypePush:
            case TransitionTypePresent:
                if (_transitionProperty.isSystemBackAnimation) {
                    removeDelegateBlock();
                }
                break;
                
            default:
                removeDelegateBlock();
                break;
        }
    }
}


#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.animationBlock ? self.animationBlock() : nil;
        self.animationBlock = nil;
    }
}


#pragma mark - 执行动画方法
- (void)transitionAnimation
{
    // 执行系统动画方法
    if ((NSInteger)_transitionProperty.animationType < (NSInteger)TransitionAnimationTypeDefault) {
        [self systemTransitionAnimatorWithIsBack:isBack];
        return;
    }
    
    // 执行自定义动画方法
    unsigned int count = 0;
    NSString *rangeStr = @"customTransitionAnimator";
    Method *methodlist = class_copyMethodList(NSClassFromString(@"TransitionAnimator"), &count);
    int tag = 0;
    
    for (int i = 0; i < count; i++) {
        
        Method method = methodlist[i];
        SEL selector = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        
        if ([methodName rangeOfString:rangeStr].location != NSNotFound) {
            tag++;
            
            if (tag == _transitionProperty.animationType-TransitionAnimationTypeDefault) {
                
                // 发送消息，即调用对应的方法
                ((void (*)(id,SEL,BOOL))objc_msgSend)(self,selector,isBack);
                break;
            }
        }
    }
    free(methodlist);
}


#pragma mark - 自定义动画方法
- (void)customTransitionAnimatorWithPageToLeft
{
    if (!isBack) {
        [self transitionNextPageAnimator];
    }else {
        [self transitionBackPageAnimator];
    }
}

- (void)customTransitionAnimatorWithPageToRight
{
    [self customTransitionAnimatorWithPageToLeft];
}

- (void)customTransitionAnimatorWithPageToTop
{
    [self customTransitionAnimatorWithPageToLeft];
}

- (void)customTransitionAnimatorWithPageToBottom
{
    [self customTransitionAnimatorWithPageToLeft];
}


@end




