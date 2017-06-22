//
//  TransitionProperty.h
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDefConfig.h"
#import <UIKit/UIKit.h>

@interface TransitionProperty : NSObject

/**
 * 转场动画时间，默认0.5s
 */
@property (nonatomic, assign) NSTimeInterval animationTime;

/**
 * 转场方式 ：push,pop,present,dismiss
 * 局限性
 */
@property (nonatomic, assign) TransitionType transitionType;

/**
 * 转场动画类型
 */
@property (nonatomic, assign) TransitionAnimationType animationType;

/**
 * 返回的转场动画类型
 */
@property (nonatomic, assign) TransitionAnimationType backAnimationType;

/**
 * 是否采用系统原生返回方式，默认为NO
 * backGestureType为BackGestureTypeNone，该字段无效
 */
@property (nonatomic, assign) BOOL isSystemBackAnimation;

/**
 * 是否通过手势返回,默认为YES
 */
//@property (nonatomic, assign) BOOL backGestureEnable;

/**
 * 返回上个界面的手势 默认：右滑BackGestureTypeRight
 * 当为BackGestureTypeNone时，手势返回无效
 * isSystemBackAnimation为YES，该字段无效，默认：右滑BackGestureTypeRight
 */
@property (nonatomic, assign) BackGestureType backGestureType;

/**
 * 在动画之前隐藏NavigationBar,动画结束后显示,默认为YES
 */
@property (nonatomic, assign) BOOL autoShowAndHideNavBar;

/**
 * 显示隐藏NavigationBar的动画时间，默认0.25s
 */
@property (nonatomic, assign) NSTimeInterval showAndHideNavBarTime;

/**
 * 交互式动画的均值，超过就执行动画。默认0.3
 * 均值 = 偏移量 / view宽或高
 */
@property (nonatomic, assign) CGFloat interactivePercent;

/**
 * 起始视图
 */
//@property (nonatomic, strong) UIView *startView;
/**
 * 结束视图
 */
//@property (nonatomic, strong) UIView *endView;

@end
