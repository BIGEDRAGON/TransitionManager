//
//  TransitionAnimation+PageAnimation.m
//  TransitionManager
//
//  Created by long on 2017/6/16.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+PageAnimation.h"

@implementation TransitionAnimator (PageAnimation)

- (void)transitionNextPageAnimator
{
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [self.transitionContext containerView];
    
    UIView *fromSnapshotView = [fromView snapshotViewAfterScreenUpdates:NO];
    
    [containerView addSubview:toView];
    [containerView addSubview:fromSnapshotView];
    [containerView insertSubview:toView atIndex:0];
    fromView.hidden = YES;
    
    // 设置anchorPoint
    CGPoint anchorPoint = CGPointZero;
    CATransform3D finalTransfrom3d = CATransform3DIdentity;
    
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypePageTransitionToLeft:
            anchorPoint = CGPointMake(0, 0.5);
            finalTransfrom3d = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
            break;
        case TransitionAnimationTypePageTransitionToRight:
            anchorPoint = CGPointMake(1, 0.5);
            finalTransfrom3d = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
            break;
        case TransitionAnimationTypePageTransitionToTop:
            anchorPoint = CGPointMake(0.5, 0);
            finalTransfrom3d = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
            break;
        case TransitionAnimationTypePageTransitionToBottom:
            anchorPoint = CGPointMake(0.5, 1);
            finalTransfrom3d = CATransform3DMakeRotation(-M_PI_2, 1, 0, 0);
            break;
            
        default:
            anchorPoint = CGPointZero;
            break;
    }
    
    fromSnapshotView.frame = CGRectOffset(fromSnapshotView.frame, (anchorPoint.x - fromSnapshotView.layer.anchorPoint.x) * fromSnapshotView.frame.size.width, (anchorPoint.y - fromSnapshotView.layer.anchorPoint.y) * fromSnapshotView.frame.size.height);
    fromSnapshotView.layer.anchorPoint = anchorPoint;
    
    // 设置主layer的transform
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -1.0/700;
    fromSnapshotView.layer.transform = transfrom3d;
    
    [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
        fromSnapshotView.layer.transform = finalTransfrom3d;
        
    } completion:^(BOOL finished) {
        
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    }];
}

- (void)transitionBackPageAnimator
{
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [self.transitionContext containerView];
    
    UIView *tempView = containerView.subviews[1];
    tempView.hidden = NO;
    [containerView addSubview:toView];
    toView.hidden = YES;
    
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -1.0/700;
    containerView.layer.sublayerTransform = transfrom3d;
    
    [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        fromView.alpha = 0.2;
        
    } completion:^(BOOL finished) {
        
        if ([self.transitionContext transitionWasCancelled]) {
            [self.transitionContext completeTransition:NO];
        }else{
            
            [tempView removeFromSuperview];
            toView.hidden = NO;
            [self.transitionContext completeTransition:YES];
        }
    }];
    
    self.interactiveBlock = ^(BOOL success) {
        if (success) {
            [fromView removeFromSuperview];
            toView.hidden = NO;
        }
    };
}

@end
