//
//  TransitionAnimator+LineSpread.m
//  TransitionManager
//
//  Created by long on 2017/7/13.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+LineSpread.h"

@implementation TransitionAnimator (LineSpread)

- (void)transitionAnimatorLineSpreadWithIsBack:(BOOL)isBack
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
    
    
    CGRect rect0 ;
    CGRect rect1 = CGRectMake(0, 0, screenWidth, screenHeight);
    
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypeLineSpreadFromLeft:
            rect0 = isBack ? CGRectMake(screenWidth-2, 0, 2, screenHeight) : CGRectMake(0, 0, 2, screenHeight);
            break;
        case TransitionAnimationTypeLineSpreadFromRight:
            rect0 = isBack ? CGRectMake(0, 0, 2, screenHeight) : CGRectMake(screenWidth, 0, 2, screenHeight);
            break;
        case TransitionAnimationTypeLineSpreadFromTop:
            rect0 = isBack ? CGRectMake(0, screenHeight - 2 , screenWidth, 2) : CGRectMake(0, 0, screenWidth, 2);
            break;
        default:
            rect0 = isBack ? CGRectMake(0, 0, screenWidth, 2) : CGRectMake(0, screenHeight , screenWidth, 2);
            break;
    }
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRect:rect0];
    UIBezierPath *endPath =[UIBezierPath bezierPathWithRect:rect1];
    
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


@end
