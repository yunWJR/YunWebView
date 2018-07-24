//
// Created by yun on 2018/7/24.
// Copyright (c) 2018 yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

- (UIImage *)imageByRotateLeft90;

- (UIImage *)imageByRotateRight90;

- (UIImage *)imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

@end