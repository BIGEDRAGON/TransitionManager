//
//  NextViewController.m
//  TransitionManager
//
//  Created by long on 2017/6/16.
//  Copyright © 2017年 xiaolong. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        CGSize size = [UIScreen mainScreen].bounds.size;
        _imageV.frame = CGRectMake((size.width-130)/2, (size.height+64-200)/2, 130, 200);
        _imageV.image = [UIImage imageNamed:@"basil"];
    }
    return _imageV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"nextVC";
    self.view.backgroundColor = [UIColor orangeColor];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake((size.width-200)/2-20, 14+(size.height-64-200)/2, 100, 50);
    [btn1 setTitle:@"pop" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    [btn1 addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(size.width/2, 14+(size.height-64-200)/2, 100, 50);
    [btn2 setTitle:@"dismiss" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    [btn2 addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.imageV];
}


- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
