//
//  TransitionDelegate.h
//  TransitionManager
//
//  Created by long on 2017/6/20.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionProperty.h"

@interface CustomDelegate : NSObject
<UINavigationControllerDelegate,
UIViewControllerTransitioningDelegate>

typedef void(^TransitionBlock)(TransitionProperty *property);

// 动画中TransitionProperty对象的block
@property (nonatomic, copy) TransitionBlock transitionBlcok;

// 是否支持侧滑返回，是则关闭
@property (nonatomic, assign) BOOL backGestureEnable;

// 返回上个界面的手势 默认：右滑 ：BackGestureTypeRight
// 当为BackGestureTypeNone时，手势返回无效
@property (nonatomic, assign) BackGestureType backGestureType;

// 是否采用系统原生动画返回方式：是为NO，不是为YES
@property (nonatomic, assign) BOOL isCustomBackAnimation;

@end
