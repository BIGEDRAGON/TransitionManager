//
//  TransitionAnimator+Portal.m
//  TransitionManager
//
//  Created by long on 2017/7/3.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+Portal.h"

@implementation TransitionAnimator (Portal)

- (void)transitionAnimatorPortalWithIsBack:(BOOL)isBack
{
//    if (!isBack) {
//        [self transitionNextPortalAnimator];
//    }else {
//        [self transitionBackPortalAnimator];
//    }
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containView = [self.transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIView *openView = isBack ? toView : fromView;
    UIView *closeView = isBack ? fromView : toView;
    
    NSArray *imgViewArr = [self imageOpenView:openView closeView:closeView];
    UIImageView *imgView0 = imgViewArr.firstObject;
    UIImageView *imgView1 = imgViewArr.lastObject;
    
    [containView addSubview:fromView];
    [containView addSubview:toView];
    [containView addSubview:imgView0];
    [containView addSubview:imgView1];
    
    
    __weak TransitionAnimator *WeakSelf = self;
    
    void(^BeginAnimationBlock)() = ^() {
        
        if ([WeakSelf animationTypeIsVertical]) {
            imgView0.layer.transform = CATransform3DMakeTranslation(0, -screenHeight/2, 0);
            imgView1.layer.transform = CATransform3DMakeTranslation(0, screenHeight/2, 0);
        }else {
            imgView0.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
            imgView1.layer.transform = CATransform3DMakeTranslation(screenWidth/2, 0, 0);
        }
        
    };
    
    void(^EndAnimationBlock)() = ^() {
        imgView0.layer.transform = CATransform3DIdentity;
        imgView1.layer.transform = CATransform3DIdentity;
    };
    
    
    CATransform3D scaleTransForm3D = CATransform3DMakeScale(0.6, 0.6, 1.0);
    
    if ((![self animationTypeIsOpen] && !isBack) ||
        ([self animationTypeIsOpen] && isBack)) {
        toView.hidden = YES;
        BeginAnimationBlock();
    }else {
        
        // solid
        if ([self animationTypeIsSolid]) {
            toView.layer.transform = scaleTransForm3D;
        }
    }
    
    
    [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
        if ((![WeakSelf animationTypeIsOpen] && !isBack) ||
            ([WeakSelf animationTypeIsOpen] && isBack)) {
            EndAnimationBlock();
        }else {
            BeginAnimationBlock();
        }
        
        
        // solid
        if ([self animationTypeIsSolid] && !isBack) {
            
            // open and close (not isBack)
            if ([self animationTypeIsOpen]) {
                fromView.hidden = YES;
                toView.layer.transform = CATransform3DIdentity;
            }else {
                fromView.layer.transform = scaleTransForm3D;
            }
            
        }else if([self animationTypeIsSolid] && isBack) {
            
            // open and close (isBack)
            if ([self animationTypeIsOpen]) {
                fromView.layer.transform = scaleTransForm3D;
            }else {
                fromView.hidden = YES;
                toView.layer.transform = CATransform3DIdentity;
            }
                
        }
        
    } completion:^(BOOL finished) {
        
        fromView.hidden = NO;
        toView.hidden = NO;
        [imgView0 removeFromSuperview];
        [imgView1 removeFromSuperview];
        if ([WeakSelf.transitionContext transitionWasCancelled]) {
            [WeakSelf.transitionContext completeTransition:NO];
        }else {
            [WeakSelf.transitionContext completeTransition:YES];
        }
    }];
    
    if (isBack) {
        self.interactiveBlock = ^(BOOL sucess) {
            if (!sucess) {
                [toView removeFromSuperview];
            }else {
                toView.hidden = NO;
                // 修复present/pop情况下，SolidClosePortal方式toView弹一下问题
                // 原因是finishInteractive的时候，toView又刷新了一次动画
                [toView.layer removeAllAnimations];
            }
            [imgView0 removeFromSuperview];
            [imgView1 removeFromSuperview];
        };
    }
}


//- (void)transitionNextPortalAnimator
//{
//    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *containView = [self.transitionContext containerView];
//    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    
//    NSArray *imgViewArr = [self imageOpenView:fromView closeView:toView];
//    UIImageView *imgView0 = imgViewArr.firstObject;
//    UIImageView *imgView1 = imgViewArr.lastObject;
//    
//    [containView addSubview:fromView];
//    [containView addSubview:toView];
//    [containView addSubview:imgView0];
//    [containView addSubview:imgView1];
//    
//    
//    __weak TransitionAnimator *WeakSelf = self;
//    
//    void(^BeginAnimationBlock)() = ^() {
//        
//        if ([WeakSelf animationTypeIsVertical]) {
//            imgView0.layer.transform = CATransform3DMakeTranslation(0, -screenHeight/2, 0);
//            imgView1.layer.transform = CATransform3DMakeTranslation(0, screenHeight/2, 0);
//        }else {
//            imgView0.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
//            imgView1.layer.transform = CATransform3DMakeTranslation(screenWidth/2, 0, 0);
//        }
//        
//    };
//    
//    void(^EndAnimationBlock)() = ^() {
//        imgView0.layer.transform = CATransform3DIdentity;
//        imgView1.layer.transform = CATransform3DIdentity;
//    };
//    
//    
//    if (![self animationTypeIsOpen]) {
//        toView.hidden = YES;
//        BeginAnimationBlock();
//    }
//    
//    [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
//        if (![WeakSelf animationTypeIsOpen]) {
//            EndAnimationBlock();
//        }else {
//            BeginAnimationBlock();
//        }
//        
//    } completion:^(BOOL finished) {
//        
//        toView.hidden = NO;
//        [imgView0 removeFromSuperview];
//        [imgView1 removeFromSuperview];
//        if ([WeakSelf.transitionContext transitionWasCancelled]) {
//            [WeakSelf.transitionContext completeTransition:NO];
//        }else {
//            [WeakSelf.transitionContext completeTransition:YES];
//        }
//    }];
//}
//
//- (void)transitionBackPortalAnimator
//{
//    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *containView = [self.transitionContext containerView];
//    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    
//    NSArray *imgViewArr = [self imageOpenView:toView closeView:fromView];
//    UIImageView *imgView0 = imgViewArr.firstObject;
//    UIImageView *imgView1 = imgViewArr.lastObject;
//    
//    [containView addSubview:fromView];
//    [containView addSubview:toView];
//    [containView addSubview:imgView0];
//    [containView addSubview:imgView1];
//    
//    __weak TransitionAnimator *WeakSelf = self;
//    
//    void(^BeginAnimationBlock)() = ^() {
//        
//        if ([WeakSelf animationTypeIsVertical]) {
//            imgView0.layer.transform = CATransform3DMakeTranslation(0, -screenHeight/2, 0);
//            imgView1.layer.transform = CATransform3DMakeTranslation(0, screenHeight/2, 0);
//        }else {
//            imgView0.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
//            imgView1.layer.transform = CATransform3DMakeTranslation(screenWidth/2, 0, 0);
//        }
//        
//    };
//    
//    void(^EndAnimationBlock)() = ^() {
//        imgView0.layer.transform = CATransform3DIdentity;
//        imgView1.layer.transform = CATransform3DIdentity;
//    };
//    
//    
//    if ([self animationTypeIsOpen]) {
//        toView.hidden = YES;
//        BeginAnimationBlock();
//    }
//    
//    [UIView animateWithDuration:self.transitionProperty.animationTime animations:^{
//        
//        if ([self animationTypeIsOpen]) {
//            EndAnimationBlock();
//        }else {
//            BeginAnimationBlock();
//        }
//        
//    } completion:^(BOOL finished) {
//        
//        toView.hidden = NO;
//        [imgView0 removeFromSuperview];
//        [imgView1 removeFromSuperview];
//        if ([WeakSelf.transitionContext transitionWasCancelled]) {
//            [WeakSelf.transitionContext completeTransition:NO];
//        }else {
//            [WeakSelf.transitionContext completeTransition:YES];
//        }
//        
//    }];
//    
//    
//    self.interactiveBlock = ^(BOOL sucess) {
//        if (!sucess) {
//            [toView removeFromSuperview];
//        }
//        [imgView0 removeFromSuperview];
//        [imgView1 removeFromSuperview];
//    };
//}


- (NSArray *)imageOpenView:(UIView *)openView closeView:(UIView *)closeView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rect0;
    CGRect rect1;
    
    if ([self animationTypeIsVertical]) {
        rect0 = CGRectMake(0 , 0 , screenWidth, screenHeight/2);
        rect1 = CGRectMake(0 , screenHeight/2 , screenWidth, screenHeight/2);
    }else {
        rect0 = CGRectMake(0 , 0 , screenWidth/2, screenHeight);
        rect1 = CGRectMake(screenWidth/2 , 0 , screenWidth/2, screenHeight);
    }
    
    
    UIView *view = [self animationTypeIsOpen] ? openView : closeView;
    
    
    UIImage *image0 = [self imageFromView:view atFrame:rect0];
    UIImage *image1 = [self imageFromView:view atFrame:rect1];
    
    UIImageView *imageView0 = [[UIImageView alloc] initWithImage:image0];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
    
    return @[imageView0, imageView1];
}

- (BOOL)animationTypeIsOpen
{
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypeNormalOpenPortalVertical:
        case TransitionAnimationTypeNormalOpenPortalHorizontal:
        case TransitionAnimationTypeSolidOpenPortalVertical:
        case TransitionAnimationTypeSolidOpenPortalHorizontal:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}
- (BOOL)animationTypeIsVertical
{
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypeNormalOpenPortalVertical:
        case TransitionAnimationTypeSolidOpenPortalVertical:
        case TransitionAnimationTypeNormalClosePortalVertical:
        case TransitionAnimationTypeSolidClosePortalVertical:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}
- (BOOL)animationTypeIsSolid
{
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypeSolidOpenPortalVertical:
        case TransitionAnimationTypeSolidOpenPortalHorizontal:
        case TransitionAnimationTypeSolidClosePortalVertical:
        case TransitionAnimationTypeSolidClosePortalHorizontal:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (UIImage *)imageFromView:(UIView *)view atFrame:(CGRect)rect{
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
}


@end
