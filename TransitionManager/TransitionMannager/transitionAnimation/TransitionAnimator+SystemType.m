//
//  TransitionAnimation+SystemType.m
//  TransitionManager
//
//  Created by long on 2017/6/15.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "TransitionAnimator+SystemType.h"

@implementation TransitionAnimator (SystemType)

#pragma mark - systemTransition

- (CATransition *)getSystemTransition
{
    return [self getSystemTransitionFromAnimationType:self.transitionProperty.animationType];
}

- (CATransition *)getSystemTransitionFromAnimationType:(TransitionAnimationType)animationType
{
    CATransition *tranAnimation=[CATransition animation];
    tranAnimation.duration= self.transitionProperty.animationTime;
    tranAnimation.delegate = self;
    switch (animationType) {
        case TransitionAnimationTypeSysFade:{
            tranAnimation.type=kCATransitionFade;
        }
            break;
        case TransitionAnimationTypeSysPushFromRight:{
            tranAnimation.type = kCATransitionPush;
            tranAnimation.subtype=kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysPushFromLeft:{
            tranAnimation.type = kCATransitionPush;
            tranAnimation.subtype=kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysPushFromTop:{
            tranAnimation.type = kCATransitionPush;
            tranAnimation.subtype=kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysPushFromBottom:{
            tranAnimation.type = kCATransitionPush;
            tranAnimation.subtype=kCATransitionFromBottom;
            
        }
            break;
        case TransitionAnimationTypeSysRevealFromRight:{
            tranAnimation.type = kCATransitionReveal;
            tranAnimation.subtype=kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysRevealFromLeft:{
            tranAnimation.type = kCATransitionReveal;
            tranAnimation.subtype=kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysRevealFromTop:{
            tranAnimation.type = kCATransitionReveal;
            tranAnimation.subtype=kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysRevealFromBottom:{
            tranAnimation.type = kCATransitionReveal;
            tranAnimation.subtype=kCATransitionFromBottom;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromRight:{
            tranAnimation.type = kCATransitionMoveIn;
            tranAnimation.subtype=kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromLeft:{
            tranAnimation.type = kCATransitionMoveIn;
            tranAnimation.subtype=kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromTop:{
            tranAnimation.type = kCATransitionMoveIn;
            tranAnimation.subtype=kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromBottom:{
            tranAnimation.type = kCATransitionMoveIn;
            tranAnimation.subtype=kCATransitionFromBottom;
        }
            break;
        case TransitionAnimationTypeSysCubeFromRight:{
            tranAnimation.type = @"cube";
            tranAnimation.subtype=kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysCubeFromLeft:{
            tranAnimation.type = @"cube";
            tranAnimation.subtype=kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysCubeFromTop:{
            tranAnimation.type = @"cube";
            tranAnimation.subtype = kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysCubeFromBottom:{
            tranAnimation.type = @"cube";
            tranAnimation.subtype = kCATransitionFromBottom;
        }
            break;
        case TransitionAnimationTypeSysSuckEffect:{
            tranAnimation.type = @"suckEffect";
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromRight:{
            tranAnimation.type = @"oglFlip";
            tranAnimation.subtype = kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromLeft:{
            tranAnimation.type = @"oglFlip";
            tranAnimation.subtype = kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromTop:{
            tranAnimation.type = @"oglFlip";
            tranAnimation.subtype = kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromBottom:{
            tranAnimation.type = @"oglFlip";
            tranAnimation.subtype = kCATransitionFromBottom;
        }
            break;
        case TransitionAnimationTypeSysRippleEffect:{
            tranAnimation.type = @"rippleEffect";
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromRight:{
            tranAnimation.type = @"pageCurl";
            tranAnimation.subtype = kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromLeft:{
            tranAnimation.type = @"pageCurl";
            tranAnimation.subtype = kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromTop:{
            tranAnimation.type = @"pageCurl";
            tranAnimation.subtype = kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromBottom:{
            tranAnimation.type = @"pageCurl";
            tranAnimation.subtype = kCATransitionFromBottom;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromRight:{
            tranAnimation.type = @"pageUnCurl";
            tranAnimation.subtype = kCATransitionFromRight;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromLeft:{
            tranAnimation.type = @"pageUnCurl";
            tranAnimation.subtype = kCATransitionFromLeft;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromTop:{
            tranAnimation.type = @"pageUnCurl";
            tranAnimation.subtype = kCATransitionFromTop;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromBottom:{
            tranAnimation.type = @"pageUnCurl";
            tranAnimation.subtype = kCATransitionFromBottom;
        }
            break;
        case TransitionAnimationTypeSysCameraIrisHollowOpen:{
            tranAnimation.type = @"cameraIrisHollowOpen";
        }
            break;
        case TransitionAnimationTypeSysCameraIrisHollowClose:{
            tranAnimation.type = @"cameraIrisHollowClose";
        }
            break;
        default:
            break;
    }
    return tranAnimation;
}



#pragma mark - systemBackTransition
- (CATransition *)getSystemBackTransition
{
    return [self getSystemTransitionFromAnimationType:[self backAnimationType]];
}

- (TransitionAnimationType)backAnimationType
{
    
    if (self.transitionProperty.backAnimationType) {
        return self.transitionProperty.backAnimationType;
    }
    
    switch (self.transitionProperty.animationType) {
        case TransitionAnimationTypeSysFade:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysFade;
        }
            break;
        case TransitionAnimationTypeSysPushFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPushFromLeft;
        }
            break;
        case TransitionAnimationTypeSysPushFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPushFromRight;
        }
            break;
        case TransitionAnimationTypeSysPushFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPushFromBottom;
        }
            break;
        case TransitionAnimationTypeSysPushFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPushFromTop;
        }
            break;
        case TransitionAnimationTypeSysRevealFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysMoveInFromLeft;
        }
            break;
        case TransitionAnimationTypeSysRevealFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysMoveInFromRight;
        }
            break;
        case TransitionAnimationTypeSysRevealFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysMoveInFromBottom;
        }
            break;
        case TransitionAnimationTypeSysRevealFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysMoveInFromTop;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysRevealFromLeft;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysRevealFromRight;
            
        }
            break;
        case TransitionAnimationTypeSysMoveInFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysRevealFromBottom;
        }
            break;
        case TransitionAnimationTypeSysMoveInFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysRevealFromTop;
        }
            break;
        case TransitionAnimationTypeSysCubeFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysCubeFromLeft;
        }
            break;
        case TransitionAnimationTypeSysCubeFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysCubeFromRight;
        }
            break;
        case TransitionAnimationTypeSysCubeFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysCubeFromBottom;
        }
            break;
        case TransitionAnimationTypeSysCubeFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysCubeFromTop;
            
        }
            break;
        case TransitionAnimationTypeSysSuckEffect:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysSuckEffect;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysOglFlipFromLeft;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysOglFlipFromRight;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysOglFlipFromBottom;
        }
            break;
        case TransitionAnimationTypeSysOglFlipFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysOglFlipFromTop;
        }
            break;
        case TransitionAnimationTypeSysRippleEffect:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysRippleEffect;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageUnCurlFromRight;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageUnCurlFromLeft;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageUnCurlFromBottom;
        }
            break;
        case TransitionAnimationTypeSysPageCurlFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageUnCurlFromTop;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromRight:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageCurlFromRight;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromLeft:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageCurlFromLeft;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromTop:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageCurlFromBottom;
        }
            break;
        case TransitionAnimationTypeSysPageUnCurlFromBottom:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysPageCurlFromTop;
        }
            break;
        case TransitionAnimationTypeSysCameraIrisHollowOpen:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysCameraIrisHollowClose;
        }
            break;
        case TransitionAnimationTypeSysCameraIrisHollowClose:{
            self.transitionProperty.backAnimationType = TransitionAnimationTypeSysCameraIrisHollowOpen;
            
        }
            break;
        default:
            break;
    }
    return self.transitionProperty.backAnimationType;
}

@end
