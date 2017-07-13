//
//  PartViewViewController.m
//  TransitionManager
//
//  Created by long on 2017/6/30.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "PartViewViewController.h"
#import "TransitionManager.h"
#import "NextViewController.h"
#import "TransitionAnimatorViewMove.h"

@interface PartViewViewController ()

@end

@implementation PartViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *name = _isPush ? @"push & " : @"present & ";
    self.navigationItem.title = [name stringByAppendingString:_titleStr];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupImageViews];
}



- (void)setupImageViews
{
    CGFloat count = 4;
    CGFloat margin = 20;
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat width = (size.width - (count+1)*margin) / count;
    CGFloat height = (size.height - 64 - (count+1)*margin) / count;
    
    for (NSInteger i = 0; i < 16; i++) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@"basil"];
        [self.view addSubview:imageV];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [imageV addGestureRecognizer:tap];
        
        CGFloat row = i / 4;// 行
        CGFloat col = i % 4;// 列
        imageV.frame = CGRectMake(margin + col*(margin+width), margin + 64 + row*(margin+height), width, height);
    }
}


- (void)imageViewClick:(UITapGestureRecognizer *)tap
{
    NextViewController *vc = [[NextViewController alloc] init];
    
    __weak PartViewViewController *weakSelf = self;
    if (_isPush) {
        
        [self.navigationController lj_pushViewController:vc transition:^(TransitionProperty *property) {
            
            property.backGestureType = BackGestureTypeLeft | BackGestureTypeRight;
            
            // 设置了customAnimator，此时animationType设置无效
//            property.animationType = TransitionAnimationTypeDefault;
            
            property.customAnimator = [weakSelf customSubClassAnimatorWithVC:vc WithTap:tap];
        }];
    }else {
        
        [self.navigationController lj_presentViewController:vc transition:^(TransitionProperty *property) {
            property.animationTime = 1;
            property.backGestureType = BackGestureTypeDown;
            
            property.customAnimator = [weakSelf customSubClassAnimatorWithVC:vc WithTap:tap];
        } completion:nil];
    }
}

- (id)customSubClassAnimatorWithVC:(NextViewController *)vc WithTap:(UITapGestureRecognizer *)tap
{
    switch (self.row) {
        case 0:
        case 1:{
            TransitionAnimatorViewMove *animator = [[TransitionAnimatorViewMove alloc] init];
            animator.viewMoveType = self.row;
            animator.startView = tap.view;
            animator.endView = vc.imageV;
            return animator;
        }
            break;
        case 2:
        case 3:{
            TransitionAnimatorCircleSpread *animator = [[TransitionAnimatorCircleSpread alloc] init];
            if (self.row == 3) {
                animator.startPoint = tap.view.center;
            }
            return animator;
        }
            break;
            
        default:
            break;
    }
    return nil;
}


@end


