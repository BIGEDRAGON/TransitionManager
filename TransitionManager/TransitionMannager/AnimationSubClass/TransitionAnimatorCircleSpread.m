//
//  TransitionAnimatorCircleSpread.m
//  TransitionManager
//
//  Created by long on 2017/7/13.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimatorCircleSpread.h"


@implementation TransitionAnimatorCircleSpread

- (void)transitionAnimationWithIsBack:(BOOL)isBack
{
    if (!isBack) {
        [self transitionNextCircleSpreadAnimator];
    }else {
        [self transitionBackCircleSpreadAnimator];
    }
}

- (void)transitionNextCircleSpreadAnimator
{
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *tempView = [toView snapshotViewAfterScreenUpdates:YES];
    UIView *containerView = [self.transitionContext containerView];
    
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    [containerView addSubview:tempView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    CGRect rect = CGRectMake(containerView.center.x - 1, containerView.center.y - 1, 2, 2);
    if (_startPoint.x || _startPoint.y) {
        rect = CGRectMake(_startPoint.x - 1, _startPoint.y - 1, 2, 2);
    }
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:sqrt(screenHeight * screenHeight + screenWidth * screenWidth) startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    tempView.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id)((endPath.CGPath));
    animation.duration = self.transitionProperty.animationTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:nil];
    
    __weak TransitionAnimator *WeakSelf = self;
    self.animationBlock = ^(){
        
        toView.hidden = NO;
        [tempView removeFromSuperview];
        
        [WeakSelf.transitionContext completeTransition:![WeakSelf.transitionContext transitionWasCancelled]];
    };
}

- (void)transitionBackCircleSpreadAnimator
{
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [self.transitionContext containerView];
    UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
    
    [containerView addSubview:toView];
    [containerView addSubview:tempView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    CGRect rect = CGRectMake(containerView.center.x-1, containerView.center.y-1, 2, 2);
    if (_startPoint.x || _startPoint.y) {
        rect = CGRectMake(_startPoint.x - 1, _startPoint.y - 1, 2, 2);
    }
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:sqrt(screenHeight * screenHeight + screenWidth * screenWidth)/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    tempView.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id)((endPath.CGPath));
    animation.duration = self.transitionProperty.animationTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:nil];
    
    __weak TransitionAnimator *WeakSelf = self;
    self.animationBlock = ^(){
        
        if ([WeakSelf.transitionContext transitionWasCancelled]) {
            [WeakSelf.transitionContext completeTransition:NO];
            [tempView removeFromSuperview];
        }else{
            
            [WeakSelf.transitionContext completeTransition:YES];
            toView.hidden = NO;
            [tempView removeFromSuperview];
        }
    };
    
    self.interactiveBlock = ^(BOOL sucess) {
        if (!sucess) {
            [toView removeFromSuperview];
        }
    };
}

@end
