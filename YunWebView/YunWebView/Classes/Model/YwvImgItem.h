//
// Created by yun on 2018/6/13.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>

@interface YwvImgItem : JSONModel

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *thumb;

+ (instancetype)itemWithImgSrc:(UIImage *)img thumb:(BOOL)thumb;

@end