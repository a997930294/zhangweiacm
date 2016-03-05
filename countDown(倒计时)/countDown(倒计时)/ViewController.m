//
//  ViewController.m
//  countDown(倒计时)
//
//  Created by 张伟 on 16/3/5.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "ViewController.h"
#import "ZWCountDownView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ZWCountDownView *countDown = [ZWCountDownView shareCoundDown];
    
    countDown.frame = CGRectMake(100,100,200,30);
    countDown.timeStamp = 10;
    countDown.backgroundImageName = @"search_k";
    countDown.timeStopBlock = ^{
      
        NSLog(@"倒计时完成");
    };
    
    [self.view addSubview:countDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
