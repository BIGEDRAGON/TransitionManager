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
    
    
    // solid
    if ((NSInteger)self.transitionProperty.animationType >= (NSInteger)TransitionAnimationTypeSolidLineSpreadFromLeft) {
        
        
        [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
            CGFloat scale = 0.8;
            toView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
            fromView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
        } completion:^(BOOL finished) {
            toView.layer.transform = CATransform3DIdentity;
            fromView.layer.transform = CATransform3DIdentity;
        }];
    }
    
    
    CGRect rect0 = CGRectZero;
    CGRect rect1 = CGRectMake(0, 0, screenWidth, screenHeight);
    
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypeLineSpreadFromLeft:
        case TransitionAnimationTypeSolidLineSpreadFromLeft:
            rect0 = isBack ? CGRectMake(screenWidth-2, 0, 2, screenHeight) : CGRectMake(0, 0, 2, screenHeight);
            break;
        case TransitionAnimationTypeLineSpreadFromRight:
        case TransitionAnimationTypeSolidLineSpreadFromRight:
            rect0 = isBack ? CGRectMake(0, 0, 2, screenHeight) : CGRectMake(screenWidth, 0, 2, screenHeight);
            break;
        case TransitionAnimationTypeLineSpreadFromTop:
        case TransitionAnimationTypeSolidLineSpreadFromTop:
            rect0 = isBack ? CGRectMake(0, screenHeight - 2 , screenWidth, 2) : CGRectMake(0, 0, screenWidth, 2);
            break;
        case TransitionAnimationTypeLineSpreadFromBottom:
        case TransitionAnimationTypeSolidLineSpreadFromBottom:
            rect0 = isBack ? CGRectMake(0, 0, screenWidth, 2) : CGRectMake(0, screenHeight , screenWidth, 2);
            break;
        default:
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
        
        
        if ([WeakSelf.transitionContext transitionWasCancelled]) {
            [WeakSelf.transitionContext completeTransition:NO];
            [tempView removeFromSuperview];
        }else {
            [WeakSelf.transitionContext completeTransition:YES];
            toView.hidden = NO;
            [tempView removeFromSuperview];
        }
    };
}


@end
