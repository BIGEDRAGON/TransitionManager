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

- (void)setTransitionType:(TransitionType)transitionType
{
    _transitionType = transitionType;
    
    switch (transitionType) {
        case TransitionTypePresent:
            _transitionType = TransitionTypeDismiss;
            break;
        case TransitionTypePush:
            _transitionType = TransitionTypePop;
            break;
            
        default:
            break;
    }
}

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
    _percent = 0;
    CGFloat totalWidth = ges.view.bounds.size.width;
    CGFloat totalHeight = ges.view.bounds.size.height;
    
    switch (_backGestureType) {
        case BackGestureTypeLeft:
        {
            CGFloat x = [ges translationInView:ges.view].x;
            _percent = -x/totalWidth;
        }
            break;
        case BackGestureTypeRight:
        {
            CGFloat x = [ges translationInView:ges.view].x;
            _percent = x/totalWidth;
        }
            break;
        case BackGestureTypeDown:
        {
            
            CGFloat y = [ges translationInView:ges.view].y;
            _percent = y/totalHeight;
            
        }
            break;
        case BackGestureTypeUp:
        {
            CGFloat y = [ges translationInView:ges.view].y;
            _percent = -y/totalHeight;
        }
            
        default:
            break;
    }
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
            _isInteractive = YES;
            [self beganGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:_percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            _isInteractive = NO;
            [self continueAction];
        }
            break;
        default:
            break;
    }
}

- (void)beganGesture
{
    switch (_transitionType) {
        case TransitionTypeDismiss:
            [_interActiveVC dismissViewControllerAnimated:YES completion:^{
            }];
            break;
        case TransitionTypePop:
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
