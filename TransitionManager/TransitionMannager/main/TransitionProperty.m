//
//  TransitionProperty.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionProperty.h"

@implementation TransitionProperty

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animationTime = 0.5;
        _animationType = TransitionAnimationTypeDefault;
//        _backGestureEnable = YES;
        _backGestureType = BackGestureTypeRight;
        _autoShowAndHideNavBar = YES;
        _showAndHideNavBarTime = 0.25;
        _interactivePercent = 0.3;
    }
    return self;
}

@end
