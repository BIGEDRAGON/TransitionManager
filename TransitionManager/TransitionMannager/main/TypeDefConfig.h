//
//  TypeDefConfig.h
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#ifndef TypedefConfig_h
#define TypedefConfig_h

typedef NS_ENUM(NSInteger, TransitionAnimationType){
    /*************** 系统 ***************/
    // 为何从1开始：因为0可以作为判断
    TransitionAnimationTypeSysFade = 1,//淡入淡出
    
    TransitionAnimationTypeSysPushFromRight,
    TransitionAnimationTypeSysPushFromLeft,
    TransitionAnimationTypeSysPushFromTop,
    TransitionAnimationTypeSysPushFromBottom,//Push
    
    TransitionAnimationTypeSysRevealFromRight,
    TransitionAnimationTypeSysRevealFromLeft,
    TransitionAnimationTypeSysRevealFromTop,
    TransitionAnimationTypeSysRevealFromBottom,//揭开
    
    TransitionAnimationTypeSysMoveInFromRight,
    TransitionAnimationTypeSysMoveInFromLeft,
    TransitionAnimationTypeSysMoveInFromTop,
    TransitionAnimationTypeSysMoveInFromBottom,//覆盖
    
    TransitionAnimationTypeSysCubeFromRight,
    TransitionAnimationTypeSysCubeFromLeft,
    TransitionAnimationTypeSysCubeFromTop,
    TransitionAnimationTypeSysCubeFromBottom,//立方体
    
    TransitionAnimationTypeSysSuckEffect,//吮吸
    
    TransitionAnimationTypeSysOglFlipFromRight,
    TransitionAnimationTypeSysOglFlipFromLeft,
    TransitionAnimationTypeSysOglFlipFromTop,
    TransitionAnimationTypeSysOglFlipFromBottom,//翻转
    
    TransitionAnimationTypeSysRippleEffect,//波纹
    
    TransitionAnimationTypeSysPageCurlFromRight,
    TransitionAnimationTypeSysPageCurlFromLeft,
    TransitionAnimationTypeSysPageCurlFromTop,
    TransitionAnimationTypeSysPageCurlFromBottom,//翻页
    
    TransitionAnimationTypeSysPageUnCurlFromRight,
    TransitionAnimationTypeSysPageUnCurlFromLeft,
    TransitionAnimationTypeSysPageUnCurlFromTop,
    TransitionAnimationTypeSysPageUnCurlFromBottom,//反翻页
    
    TransitionAnimationTypeSysCameraIrisHollowOpen, //开镜头
    TransitionAnimationTypeSysCameraIrisHollowClose,//关镜头
    
    /*************** 自定义 ***************/
    TransitionAnimationTypeDefault,// TransitionAnimationTypeSysRevealFromRight
    
    TransitionAnimationTypePageToLeft,  // 左翻页
    TransitionAnimationTypePageToRight, // 右翻页
    TransitionAnimationTypePageToTop,   // 上翻页
    TransitionAnimationTypePageToBottom,// 下翻页
    
    TransitionAnimationTypeNormalOpenPortalVertical,    // 垂直开门式
    TransitionAnimationTypeNormalOpenPortalHorizontal,  // 水平开门式
    TransitionAnimationTypeNormalClosePortalVertical,   // 垂直关门式
    TransitionAnimationTypeNormalClosePortalHorizontal, // 水平关门式
    TransitionAnimationTypeSolidOpenPortalVertical,     // 垂直开门式(立体)
    TransitionAnimationTypeSolidOpenPortalHorizontal,   // 水平开门式(立体)
    TransitionAnimationTypeSolidClosePortalVertical,    // 垂直关门式(立体)
    TransitionAnimationTypeSolidClosePortalHorizontal,  // 水平关门式(立体)
    
    TransitionAnimationTypeRotationPresentFromLeft, // 左旋转弹出
    TransitionAnimationTypeRotationPresentFromRight,// 右旋转弹出
    
    TransitionAnimationTypeLineSpreadFromLeft,  // 左线性扩展
    TransitionAnimationTypeLineSpreadFromRight, // 右线性扩展
    TransitionAnimationTypeLineSpreadFromTop,   // 上线性扩展
    TransitionAnimationTypeLineSpreadFromBottom,// 下线性扩展
};

typedef NS_ENUM(NSInteger,TransitionType){
    TransitionTypePop,
    TransitionTypePush,
    TransitionTypePresent,
    TransitionTypeDismiss
};

typedef NS_ENUM(NSInteger,BackGestureType){
    BackGestureTypeNone     =   0,
    BackGestureTypeLeft     =   1 << 0,
    BackGestureTypeRight    =   1 << 1,
    BackGestureTypeUp       =   1 << 2,
    BackGestureTypeDown     =   1 << 3
};


#endif /* TypeDefConfig_h */
