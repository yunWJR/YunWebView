//
// Created by yun on 2017/11/23.
// Copyright (c) 2017 skkj. All rights reserved.
//

#import "YunH2Nv.h"

@interface YunH2Nv () {
}

@end

@implementation YunH2Nv

+ (instancetype)nvWithVc:(UIViewController *)vc {
    //vc = [BdVcTest new];

    YunH2Nv *nc = [[YunH2Nv alloc] initWithRootViewController:vc];
    nc.vc = vc;

    return nc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.transform = CGAffineTransformMakeRotation((CGFloat) M_PI_2);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end