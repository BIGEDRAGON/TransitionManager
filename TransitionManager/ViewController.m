//
//  ViewController.m
//  TransitionManager
//
//  Created by long on 2017/6/14.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)systemPushClick:(id)sender {
    
    TableViewController *systemVC = [[TableViewController alloc] init];
    systemVC.isPush = YES;
    systemVC.isSystem = YES;
    [self.navigationController pushViewController:systemVC animated:YES];
}
- (IBAction)systemPresentClick:(id)sender {
    
    TableViewController *systemVC = [[TableViewController alloc] init];
    systemVC.isPush = NO;
    systemVC.isSystem = YES;
    [self.navigationController pushViewController:systemVC animated:YES];
}

- (IBAction)customPushClick:(id)sender {
    
    TableViewController *customVC = [[TableViewController alloc] init];
    customVC.isPush = YES;
    customVC.isSystem = NO;
    [self.navigationController pushViewController:customVC animated:YES];
}
- (IBAction)customPresentClick:(id)sender {
    
    TableViewController *customVC = [[TableViewController alloc] init];
    customVC.isPush = NO;
    customVC.isSystem = NO;
    [self.navigationController pushViewController:customVC animated:YES];
}



@end
