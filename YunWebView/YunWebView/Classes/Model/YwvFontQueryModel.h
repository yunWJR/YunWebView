//
// Created by yun on 2018/6/15.
// Copyright (c) 2018 skkj. All rights reserved.
//

#import "JSONModel.h"

@interface YwvFontQueryModel : JSONModel

// 字体类型：
// 1 -- 细体
// 2 -- 粗体
@property (nonatomic, assign) NSInteger fontType;

+ (instancetype)modelWithData:(id)data;

@end