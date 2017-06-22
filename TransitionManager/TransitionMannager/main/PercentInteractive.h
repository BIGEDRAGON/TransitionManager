//
//  PercentInteractive.h
//  TransitionManager
//
//  Created by long on 2017/6/21.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransitionAnimator;

@interface PercentInteractive : UIPercentDrivenInteractiveTransition

+ (instancetype)interactiveWithVC:(UIViewController *)interactiveVC animator:(TransitionAnimator *)animator;

@property (nonatomic, assign) BOOL isInteractive;

// 交互式动画执行结束Block。success：是否成功
@property (nonatomic, copy) void(^interactiveBlock)(BOOL success);

@end
