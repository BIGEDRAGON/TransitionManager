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
    TransitionAnimationTypeSysOglFlipFromBottom, //翻转
    
    TransitionAnimationTypeSysRippleEffect,//波纹
    
    TransitionAnimationTypeSysPageCurlFromRight,
    TransitionAnimationTypeSysPageCurlFromLeft,
    TransitionAnimationTypeSysPageCurlFromTop,
    TransitionAnimationTypeSysPageCurlFromBottom,//翻页
    
    TransitionAnimationTypeSysPageUnCurlFromRight,
    TransitionAnimationTypeSysPageUnCurlFromLeft,
    TransitionAnimationTypeSysPageUnCurlFromTop,
    TransitionAnimationTypeSysPageUnCurlFromBottom,//反翻页
    
    TransitionAnimationTypeSysCameraIrisHollowOpen,//开镜头
    
    TransitionAnimationTypeSysCameraIrisHollowClose,//关镜头
    
    /*************** 自定义 ***************/
    TransitionAnimationTypeDefault,
    
    TransitionAnimationTypePageTransition
};

typedef NS_ENUM(NSInteger,TransitionType){
    TransitionTypePop,
    TransitionTypePush,
    TransitionTypePresent,
    TransitionTypeDismiss
};

typedef NS_ENUM(NSInteger,BackGestureType){
    BackGestureTypeNone     =   0,
    BackGestureTypeRight    =   1 << 0,
    BackGestureTypeLeft     =   1 << 1,
    BackGestureTypeDown     =   1 << 2,
    BackGestureTypeUp       =   1 << 3
};


#endif /* TypeDefConfig_h */
