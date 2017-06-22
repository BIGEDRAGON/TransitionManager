//
//  TransitionDelegate.m
//  TransitionManager
//
//  Created by long on 2017/6/20.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "CustomDelegate.h"
#import "TransitionAnimator.h"
#import "PercentInteractive.h"

@interface CustomDelegate ()
@property (nonatomic, strong) TransitionAnimator *animator;
@property (nonatomic, strong) PercentInteractive *interactive;

@property (nonatomic, strong) UIViewController *interActiveVC;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, copy) void(^tempBlock)();
@end

@implementation CustomDelegate

#pragma mark - set PercentInteractive对象
- (void)setPercentInteractiveWithVC:(UIViewController *)vc
{
    __weak CustomDelegate *WeakSelf = self;
    self.tempBlock = ^{
        if (_isCustomBackAnimation && _backGestureType != BackGestureTypeNone) {
            
            !WeakSelf.interactive ? WeakSelf.interactive = [PercentInteractive interactiveWithVC:vc animator:WeakSelf.animator] : nil;
        }
    };
}

#pragma mark - get TransitionAnimation对象
- (TransitionAnimator *)getTransitionAnimationWithTransitionType:(TransitionType)transitionType
{
    !_animator ? _animator = [[TransitionAnimator alloc] init] : nil;
    
    TransitionProperty *property = [[TransitionProperty alloc] init];
    if (self.transitionBlcok) {
        self.transitionBlcok(property);
    }
    self.backGestureEnable = property.backGestureType ? NO : YES;
    self.backGestureType = property.backGestureType;
    self.isCustomBackAnimation = !property.isSystemBackAnimation;
    
    property.transitionType = transitionType;
    
    _animator.transitionProperty = property;
    
    if (self.tempBlock) {
        self.tempBlock();
    }
    
    return _animator;
}


#pragma mark - Present & Dismiss
#pragma mark <UIViewControllerTransitioningDelegate>
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    [self setPercentInteractiveWithVC:presented];
    
    return [self getTransitionAnimationWithTransitionType:TransitionTypePresent];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _interactive.isInteractive ? _interactive : nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [self getTransitionAnimationWithTransitionType:TransitionTypeDismiss];
}


#pragma mark - Push & Pop
#pragma mark <UINavigationControllerDelegate>
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (_operation == UINavigationControllerOperationPop) {
        return _interactive.isInteractive ? _interactive : nil;
    }else {
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    _operation = operation;
    
    TransitionType transitionType = TransitionTypePop;
    if (_operation == UINavigationControllerOperationPush) {
        transitionType = TransitionTypePush;
        
        [self setPercentInteractiveWithVC:toVC];
    }else {
        transitionType = TransitionTypePop;
    }
    
    return [self getTransitionAnimationWithTransitionType:transitionType];
}


@end
