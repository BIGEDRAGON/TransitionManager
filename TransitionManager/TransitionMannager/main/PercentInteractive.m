//
//  PercentInteractive.m
//  TransitionManager
//
//  Created by long on 2017/6/21.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "PercentInteractive.h"
#import "TransitionAnimator.h"

@interface PercentInteractive ()

@property (nonatomic, strong) UIViewController *interActiveVC;

@property (nonatomic, assign) TransitionType transitionType;
@property (nonatomic, assign) BackGestureType backGestureType;
@property (nonatomic, assign) CGFloat interActivePercent;

@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end


@implementation PercentInteractive

+ (instancetype)interactiveWithVC:(UIViewController *)interactiveVC animator:(TransitionAnimator *)animator
{
    PercentInteractive *interactive = [[PercentInteractive alloc] init];
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:interactive action:@selector(panGesture:)];
    [interactiveVC.view addGestureRecognizer:ges];
    interactive.interActiveVC = interactiveVC;
    
    // 设置属性
    interactive.transitionType = animator.transitionProperty.transitionType;
    interactive.backGestureType = animator.transitionProperty.backGestureType;
    interactive.interActivePercent = animator.transitionProperty.interactivePercent;
    interactive.interactiveBlock = ^(BOOL suceess) {
        animator.interactiveBlock ? animator.interactiveBlock(suceess) : nil;
    };
    
    return interactive;
}

- (void)panGesture:(UIPanGestureRecognizer *)ges
{
    if (_backGestureType == BackGestureTypeNone) {
        return;
    }
    
    _percent = 0;
    CGFloat totalWidth = ges.view.bounds.size.width;
    CGFloat totalHeight = ges.view.bounds.size.height;
    
    CGFloat x = [ges translationInView:ges.view].x;
    CGFloat y = [ges translationInView:ges.view].y;
    
    
    if (_backGestureType & BackGestureTypeLeft) {
        _percent = x/totalWidth;
    }
    
    if (_backGestureType & BackGestureTypeRight) {
        _percent = -x/totalWidth;
    }
    
    if (_backGestureType & BackGestureTypeUp) {
        _percent = -y/totalHeight;
    }
    
    if (_backGestureType & BackGestureTypeDown) {
        _percent = y/totalHeight;
    }
    
    if (_backGestureType == (BackGestureTypeLeft|BackGestureTypeRight)) {
        _percent = fabs(_percent);
    }
    if (_backGestureType == (BackGestureTypeUp|BackGestureTypeDown)) {
        _percent = fabs(_percent);
    }
    
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_percent >= 0) {
                _isInteractive = YES;
                [self beganGesture];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_isInteractive) {
                [self updateInteractiveTransition:_percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (_isInteractive) {
                _isInteractive = NO;
                [self continueAction];
            }
        }
            break;
        default:
            break;
    }
}

- (void)beganGesture
{
    switch (_transitionType) {
        case TransitionTypePresent:
            [_interActiveVC dismissViewControllerAnimated:YES completion:^{
            }];
            break;
        case TransitionTypePush:
            [_interActiveVC.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)continueAction
{
    if (_displayLink) {
        return;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(UIChange)];
    [_displayLink  addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)UIChange
{
    CGFloat timeDistance = 2.0/60;
    if (_percent > _interActivePercent) {
        _percent += timeDistance;
    }else {
        _percent -= timeDistance;
    }
    [self updateInteractiveTransition:_percent];
    
    if (_percent >= 1.0) {
        _interactiveBlock ? _interactiveBlock(YES) : nil;
        [self finishInteractiveTransition];
        
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_percent <= 0.0) {
        _interactiveBlock ? _interactiveBlock(NO) : nil;
        [self cancelInteractiveTransition];
        
        [_displayLink invalidate];
        _displayLink = nil;
    }
}


@end
